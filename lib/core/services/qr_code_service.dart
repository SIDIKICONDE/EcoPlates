import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logger_service.dart';
import 'qr_security_config_service.dart';
import 'secure_storage_service.dart';
import 'time_sync_service.dart';
import 'totp_service.dart';

/// Service pour la génération et gestion des QR codes sécurisés
class QRCodeService {
  QRCodeService({
    required SecureStorageService secureStorage,
    required TOTPService totpService,
    required QRSecurityConfigService configService,
    required TimeSyncService timeSyncService,
    LoggerService? logger,
  }) : _secureStorage = secureStorage,
       _totpService = totpService,
       _configService = configService,
       _timeSyncService = timeSyncService,
       _logger =
           logger ??
           LoggerService(
             defaultTag: 'QRCodeService',
             outputs: [ConsoleLogOutput().log],
           );

  final SecureStorageService _secureStorage;
  final TOTPService _totpService;
  final QRSecurityConfigService _configService;
  final TimeSyncService _timeSyncService;
  final LoggerService _logger;

  // Version du protocole QR
  static const String _protocolVersion = '2.0';

  /// Génère un QR code sécurisé pour une commande
  Future<QRPayload> generateSecureQRCode({
    required String orderId,
    required String merchantId,
    required String consumerId,
    String? deviceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Récupèrer la configuration
      final config = await _configService.getConfiguration();

      // Vérifier si on peut générer hors-ligne
      final lastOnline = _timeSyncService.synchronizedTime;
      if (!_configService.canGenerateOffline(lastOnline, config)) {
        throw Exception(
          'Offline generation limit exceeded. Please go online to sync.',
        );
      }

      // Récupère ou génère le secret TOTP
      final secretData = await _getOrCreateSecret(
        orderId,
        deviceId,
        config,
        metadata,
      );

      // Génère le code TOTP actuel avec config
      final totp = await _totpService.generateTOTP(
        secretData.secret,
        config: config,
      );
      final timestamp =
          _timeSyncService.synchronizedTime.millisecondsSinceEpoch;

      // Construit le payload
      final payload = <String, dynamic>{
        'v': config.protocolVersion,
        'merchant_id': merchantId,
        'consumer_id': consumerId,
        'order_id': orderId,
        'timestamp': timestamp,
        'token': totp,
      };

      // Ajouter device binding si activé
      if (config.enableDeviceBinding && deviceId != null) {
        payload['device_id'] = deviceId;
        payload['device_hash'] = _hashDeviceId(deviceId);
      }

      // Génère la signature HMAC
      final signature = _totpService.generateHMACSignature(
        payload,
        secretData.secret,
      );
      payload['sig'] = signature;

      // Compresse le payload si nécessaire
      final compressedData = config.compressionEnabled
          ? await _compressPayload(payload)
          : base64Url.encode(utf8.encode(jsonEncode(payload)));

      return QRPayload(
        orderId: orderId,
        rawData: compressedData,
        payload: payload,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(
          Duration(seconds: config.qrExpirationSeconds),
        ),
        deviceId: deviceId,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to generate secure QR code',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Récupère ou crée un secret TOTP
  Future<TOTPSecretData> _getOrCreateSecret(
    String orderId,
    String? deviceId,
    QRSecurityConfig config,
    Map<String, dynamic>? metadata,
  ) async {
    // Pour la révocation granulaire, utiliser orderId+deviceId comme clé
    final secretKey = config.enableGranularRevocation && deviceId != null
        ? '${orderId}_$deviceId'
        : orderId;

    var secretData = await _secureStorage.getTOTPSecret(secretKey);

    if (secretData == null) {
      // Génère un nouveau secret
      final secret = _totpService.generateSecret();
      await _secureStorage.storeTOTPSecret(
        orderId: secretKey,
        secret: secret,
        metadata: {
          ...?metadata,
          'deviceId': deviceId,
          'granularRevocation': config.enableGranularRevocation,
        },
      );
      secretData = TOTPSecretData(
        secret: secret,
        createdAt: DateTime.now(),
        metadata: metadata,
      );
    }

    return secretData;
  }

  /// Hash le device ID pour sécurité supplémentaire
  String _hashDeviceId(String deviceId) {
    final bytes = utf8.encode(deviceId);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).substring(0, 16);
  }

  /// Compresse le payload pour optimiser la taille du QR code
  Future<String> _compressPayload(Map<String, dynamic> payload) async {
    try {
      // Pour des performances optimales, utilise un isolate
      if (!kIsWeb) {
        return await compute(_compressPayloadInIsolate, payload);
      }

      // Fallback pour le web
      final jsonStr = jsonEncode(payload);
      final bytes = utf8.encode(jsonStr);

      // Compression zlib
      final compressed = zlib.encode(bytes);

      // Encode en Base64URL
      return base64Url.encode(compressed);
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to compress payload',
        error: e,
        stackTrace: stackTrace,
      );
      // En cas d'erreur, retourne le JSON non compressé
      return base64Url.encode(utf8.encode(jsonEncode(payload)));
    }
  }

  /// Fonction isolée pour la compression
  static String _compressPayloadInIsolate(Map<String, dynamic> payload) {
    final jsonStr = jsonEncode(payload);
    final bytes = utf8.encode(jsonStr);
    final compressed = zlib.encode(bytes);
    return base64Url.encode(compressed);
  }

  /// Décompresse et valide un QR code
  Future<Map<String, dynamic>?> decodeQRCode(String qrData) async {
    try {
      // Décode le Base64URL
      final compressed = base64Url.decode(qrData);

      // Décompresse
      final bytes = zlib.decode(compressed);
      final jsonStr = utf8.decode(bytes);

      // Parse JSON
      final payload = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Valide la version du protocole
      if (payload['v'] != _protocolVersion) {
        _logger.warning('Unsupported QR protocol version: ${payload['v']}');
        return null;
      }

      return payload;
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to decode QR code',
        error: e,
        stackTrace: stackTrace,
      );

      // Essaie de décoder comme JSON non compressé
      try {
        final jsonBytes = base64Url.decode(qrData);
        final jsonStr = utf8.decode(jsonBytes);
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } on Exception catch (_) {
        return null;
      }
    }
  }

  /// Valide localement un QR code (vérifications de base)
  Future<QRValidationResult> validateQRCodeLocally(String qrData) async {
    try {
      // Décode le QR
      final payload = await decodeQRCode(qrData);
      if (payload == null) {
        return const QRValidationResult(
          isValid: false,
          error: 'INVALID_FORMAT',
          message: 'Format du QR code invalide',
        );
      }

      // Vérifie la présence des champs requis
      final requiredFields = [
        'v',
        'merchant_id',
        'consumer_id',
        'order_id',
        'timestamp',
        'token',
        'sig',
      ];
      for (final field in requiredFields) {
        if (!payload.containsKey(field)) {
          return QRValidationResult(
            isValid: false,
            error: 'MISSING_FIELD',
            message: 'Champ manquant: $field',
          );
        }
      }

      // Vérifie l'expiration (timestamp)
      final timestamp = payload['timestamp'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age > 60000) {
        // Plus d'une minute
        return const QRValidationResult(
          isValid: false,
          error: 'EXPIRED',
          message: 'QR code expiré',
        );
      }

      return QRValidationResult(
        isValid: true,
        payload: payload,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to validate QR code locally',
        error: e,
        stackTrace: stackTrace,
      );
      return const QRValidationResult(
        isValid: false,
        error: 'VALIDATION_ERROR',
        message: 'Erreur lors de la validation',
      );
    }
  }

  /// Révoque un secret TOTP (support révocation granulaire)
  Future<void> revokeSecret(String orderId, {String? deviceId}) async {
    try {
      final config = await _configService.getConfiguration();

      if (config.enableGranularRevocation && deviceId != null) {
        // Révocation spécifique à un appareil
        final secretKey = '${orderId}_$deviceId';
        await _secureStorage.deleteTOTPSecret(secretKey);
        _logger.info(
          'TOTP secret revoked for order: $orderId, device: $deviceId',
        );
      } else {
        // Révocation globale
        await _secureStorage.deleteTOTPSecret(orderId);

        // Si granulaire activé, révoquer aussi tous les secrets par device
        if (config.enableGranularRevocation) {
          final allSecrets = await _secureStorage.getAllTOTPSecrets();
          for (final entry in allSecrets.entries) {
            if (entry.key.startsWith('${orderId}_')) {
              await _secureStorage.deleteTOTPSecret(entry.key);
            }
          }
        }

        _logger.info('All TOTP secrets revoked for order: $orderId');
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to revoke TOTP secret',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Nettoie les secrets expirés
  Future<void> cleanupExpiredSecrets() async {
    try {
      final count = await _secureStorage.cleanupExpiredSecrets();
      _logger.info('Cleaned up $count expired secrets');
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to cleanup expired secrets',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Modèle pour le payload QR généré
@immutable
class QRPayload {
  const QRPayload({
    required this.orderId,
    required this.rawData,
    required this.payload,
    required this.createdAt,
    required this.expiresAt,
    this.deviceId,
  });

  final String orderId;
  final String rawData; // Données compressées pour le QR
  final Map<String, dynamic> payload; // Payload décompressé
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? deviceId;

  /// Vérifie si le QR est expiré
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Temps restant avant expiration
  Duration get timeRemaining => expiresAt.difference(DateTime.now());
}

/// Résultat de validation QR
@immutable
class QRValidationResult {
  const QRValidationResult({
    required this.isValid,
    this.payload,
    this.error,
    this.message,
  });

  final bool isValid;
  final Map<String, dynamic>? payload;
  final String? error;
  final String? message;
}

/// Provider pour le service QR Code
final qrCodeServiceProvider = Provider<QRCodeService>((ref) {
  return QRCodeService(
    secureStorage: ref.watch(secureStorageServiceProvider),
    totpService: ref.watch(totpServiceProvider),
    configService: ref.watch(qrSecurityConfigServiceProvider),
    timeSyncService: ref.watch(timeSyncServiceProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour générer un QR code pour une commande spécifique
final FutureProvider<QRPayload?> Function(String) qrCodeProvider =
    FutureProvider.family<QRPayload?, String>((ref, orderId) async {
      final service = ref.watch(qrCodeServiceProvider);

      // TODO: Récupérer merchantId et consumerId depuis le contexte/state
      const merchantId = 'test-merchant-id';
      const consumerId = 'test-consumer-id';

      try {
        return await service.generateSecureQRCode(
          orderId: orderId,
          merchantId: merchantId,
          consumerId: consumerId,
        );
      } on Exception {
        return null;
      }
    });

/// Provider pour le QR code actuel avec auto-refresh
final StreamProvider<QRPayload?> Function(String) currentQRCodeProvider =
    StreamProvider.family<QRPayload?, String>((ref, orderId) async* {
      final service = ref.watch(qrCodeServiceProvider);

      // TODO: Récupérer merchantId et consumerId depuis le contexte/state
      const merchantId = 'test-merchant-id';
      const consumerId = 'test-consumer-id';

      while (true) {
        try {
          final payload = await service.generateSecureQRCode(
            orderId: orderId,
            merchantId: merchantId,
            consumerId: consumerId,
          );

          yield payload;

          // Attendre avant la prochaine rotation (25 secondes pour une marge)
          await Future<void>.delayed(const Duration(seconds: 25));
        } on Exception {
          yield null;
          await Future<void>.delayed(
            const Duration(seconds: 5),
          ); // Retry après erreur
        }
      }
    });
