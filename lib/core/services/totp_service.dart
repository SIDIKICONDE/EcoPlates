import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:otp/otp.dart';

import 'logger_service.dart';
import 'qr_security_config_service.dart';
import 'time_sync_service.dart';

/// Service pour la génération et validation de codes TOTP sécurisés
class TOTPService {
  TOTPService({
    required TimeSyncService timeSyncService,
    required QRSecurityConfigService configService,
    required LoggerService logger,
  }) : _timeSyncService = timeSyncService,
       _configService = configService,
       _logger = logger;

  final TimeSyncService _timeSyncService;
  final QRSecurityConfigService _configService;
  final LoggerService _logger;

  /// Génère un secret TOTP aléatoire sécurisé (256 bits)
  String generateSecret() {
    try {
      // Génère 32 bytes (256 bits) aléatoires sécurisés
      final secureRandom = SecureRandom();
      final bytes = secureRandom.nextBytes(32);

      // Encode en Base32 pour compatibilité TOTP standard
      final base32Secret = base32.encode(bytes);

      _logger.info('Generated new TOTP secret');
      return base32Secret;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to generate TOTP secret',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Génère le code TOTP actuel pour un secret donné
  Future<String> generateTOTP(
    String secret, {
    DateTime? time,
    QRSecurityConfig? config,
  }) async {
    try {
      config ??= await _configService.getConfiguration();
      final now = time ?? _timeSyncService.synchronizedTime;
      final millisecondsSinceEpoch = now.millisecondsSinceEpoch;

      final code = OTP.generateTOTPCodeString(
        secret,
        millisecondsSinceEpoch,
        length: config.totpDigits,
        interval: config.totpPeriodSeconds,
      );

      return code;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to generate TOTP',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Valide un code TOTP avec fenêtre de tolérance
  Future<bool> validateTOTP(
    String secret,
    String token, {
    DateTime? time,
    int? windowSteps,
    QRSecurityConfig? config,
  }) async {
    try {
      config ??= await _configService.getConfiguration();
      windowSteps ??= config.totpWindowSteps;
      final now = time ?? _timeSyncService.synchronizedTime;

      // Vérifie le token dans la fenêtre de temps
      for (var i = -windowSteps; i <= windowSteps; i++) {
        final checkTime = now.add(
          Duration(seconds: i * config.totpPeriodSeconds),
        );
        final expectedToken = await generateTOTP(
          secret,
          time: checkTime,
          config: config,
        );

        if (constantTimeCompare(token, expectedToken)) {
          _logger.debug(
            'TOTP validated with offset: ${i * config.totpPeriodSeconds}s',
          );
          return true;
        }
      }

      return false;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to validate TOTP',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Obtient le temps restant avant la prochaine rotation (en secondes)
  Future<int> getTimeRemaining({
    DateTime? time,
    QRSecurityConfig? config,
  }) async {
    config ??= await _configService.getConfiguration();
    final now = time ?? _timeSyncService.synchronizedTime;
    final secondsSinceEpoch = now.millisecondsSinceEpoch ~/ 1000;
    final timeStep = secondsSinceEpoch ~/ config.totpPeriodSeconds;
    final nextTimeStep = (timeStep + 1) * config.totpPeriodSeconds;
    return nextTimeStep - secondsSinceEpoch;
  }

  /// Obtient le pourcentage de temps écoulé dans la période actuelle
  Future<double> getProgressPercentage({
    DateTime? time,
    QRSecurityConfig? config,
  }) async {
    config ??= await _configService.getConfiguration();
    final remaining = await getTimeRemaining(time: time, config: config);
    final elapsed = config.totpPeriodSeconds - remaining;
    return elapsed / config.totpPeriodSeconds;
  }

  /// Génère la signature HMAC-SHA256 pour le payload QR
  String generateHMACSignature(Map<String, dynamic> payload, String secret) {
    try {
      // Trie les clés pour assurer une signature cohérente
      final sortedKeys = payload.keys.toList()..sort();
      final sortedPayload = <String, dynamic>{};
      for (final key in sortedKeys) {
        sortedPayload[key] = payload[key];
      }

      // Convertit en JSON sans la clé signature
      final payloadJson = jsonEncode(sortedPayload);
      final payloadBytes = utf8.encode(payloadJson);
      final secretBytes = base32.decode(secret);

      // Calcule HMAC-SHA256
      final hmac = Hmac(sha256, secretBytes);
      final digest = hmac.convert(payloadBytes);

      return base64Url.encode(digest.bytes);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to generate HMAC signature',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Vérifie la signature HMAC-SHA256 d'un payload
  bool verifyHMACSignature(
    Map<String, dynamic> payload,
    String signature,
    String secret,
  ) {
    try {
      // Enlève la signature du payload pour la vérification
      final payloadCopy = Map<String, dynamic>.from(payload);
      payloadCopy.remove('signature');
      payloadCopy.remove('sig'); // Support des deux formats

      final expectedSignature = generateHMACSignature(payloadCopy, secret);
      return constantTimeCompare(signature, expectedSignature);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to verify HMAC signature',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Comparaison constante pour éviter les timing attacks
  @visibleForTesting
  bool constantTimeCompare(String a, String b) {
    if (a.length != b.length) return false;

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }

    return result == 0;
  }

  /// Calcule le hash d'un QR code pour l'anti-replay
  String computeQRHash(String qrData) {
    final bytes = utf8.encode(qrData);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes);
  }
}

/// Générateur de nombres aléatoires sécurisés
class SecureRandom {
  /// Génère des bytes aléatoires cryptographiquement sécurisés
  Uint8List nextBytes(int length) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
}

/// Provider pour le service TOTP
final totpServiceProvider = Provider<TOTPService>((ref) {
  return TOTPService(
    timeSyncService: ref.watch(timeSyncServiceProvider),
    configService: ref.watch(qrSecurityConfigServiceProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour obtenir le temps restant avant rotation (stream)
final totpTimerProvider = StreamProvider<int>((ref) async* {
  final totpService = ref.watch(totpServiceProvider);

  while (true) {
    yield await totpService.getTimeRemaining();
    await Future<void>.delayed(const Duration(seconds: 1));
  }
});

/// Provider pour obtenir la progression en pourcentage
final totpProgressProvider = StreamProvider<double>((ref) async* {
  final totpService = ref.watch(totpServiceProvider);

  while (true) {
    yield await totpService.getProgressPercentage();
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
});
