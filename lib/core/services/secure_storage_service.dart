import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'logger_service.dart';

/// Service pour le stockage sécurisé des secrets TOTP et autres données sensibles
class SecureStorageService {
  SecureStorageService({
    FlutterSecureStorage? storage,
    LoggerService? logger,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _logger =
           logger ??
           LoggerService(
             defaultTag: 'SecureStorageService',
             outputs: [ConsoleLogOutput().log],
           );

  final FlutterSecureStorage _storage;
  final LoggerService _logger;

  // Configuration iOS Keychain
  static IOSOptions get _iOSOptions => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
    accountName: 'ecoplates_secure',
  );

  // Configuration Android Keystore
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'ecoplates_secure_prefs',
    preferencesKeyPrefix: 'ecoplates_',
  );

  // Clés de stockage
  static const String _orderSecretsPrefix = 'order_secret_';
  static const String _deviceIdKey = 'device_id';
  static const String _certificatePinKey = 'certificate_pins';

  /// Stocke le secret TOTP pour une commande
  Future<void> storeTOTPSecret({
    required String orderId,
    required String secret,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final key = '$_orderSecretsPrefix$orderId';
      final data = {
        'secret': secret,
        'createdAt': DateTime.now().toIso8601String(),
        'metadata': metadata,
      };

      await _storage.write(
        key: key,
        value: jsonEncode(data),
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      _logger.info('TOTP secret stored for order: $orderId');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to store TOTP secret',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Récupère le secret TOTP pour une commande
  Future<TOTPSecretData?> getTOTPSecret(String orderId) async {
    try {
      final key = '$_orderSecretsPrefix$orderId';
      final value = await _storage.read(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      if (value == null) {
        return null;
      }

      final data = jsonDecode(value) as Map<String, dynamic>;
      return TOTPSecretData.fromJson(data);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to retrieve TOTP secret',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Supprime le secret TOTP d'une commande
  Future<void> deleteTOTPSecret(String orderId) async {
    try {
      final key = '$_orderSecretsPrefix$orderId';
      await _storage.delete(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      _logger.info('TOTP secret deleted for order: $orderId');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to delete TOTP secret',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Liste tous les secrets TOTP stockés
  Future<Map<String, TOTPSecretData>> getAllTOTPSecrets() async {
    try {
      final allData = await _storage.readAll(
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      final secrets = <String, TOTPSecretData>{};

      for (final entry in allData.entries) {
        if (entry.key.startsWith(_orderSecretsPrefix)) {
          final orderId = entry.key.replaceFirst(_orderSecretsPrefix, '');
          final data = jsonDecode(entry.value) as Map<String, dynamic>;
          secrets[orderId] = TOTPSecretData.fromJson(data);
        }
      }

      return secrets;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to retrieve all TOTP secrets',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Nettoie les secrets expirés
  Future<int> cleanupExpiredSecrets() async {
    try {
      final allSecrets = await getAllTOTPSecrets();
      var deletedCount = 0;

      for (final entry in allSecrets.entries) {
        final createdAt = entry.value.createdAt;
        const expiryDuration = Duration(hours: 24); // Secrets valides 24h

        if (DateTime.now().difference(createdAt) > expiryDuration) {
          await deleteTOTPSecret(entry.key);
          deletedCount++;
        }
      }

      _logger.info('Cleaned up $deletedCount expired TOTP secrets');
      return deletedCount;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to cleanup expired secrets',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Stocke l'ID unique du device
  Future<void> storeDeviceId(String deviceId) async {
    try {
      await _storage.write(
        key: _deviceIdKey,
        value: deviceId,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to store device ID',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Récupère l'ID unique du device
  Future<String?> getDeviceId() async {
    try {
      return await _storage.read(
        key: _deviceIdKey,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to retrieve device ID',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Stocke les pins de certificat pour le certificate pinning
  Future<void> storeCertificatePins(List<String> pins) async {
    try {
      await _storage.write(
        key: _certificatePinKey,
        value: jsonEncode(pins),
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to store certificate pins',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Récupère les pins de certificat
  Future<List<String>> getCertificatePins() async {
    try {
      final value = await _storage.read(
        key: _certificatePinKey,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      if (value == null) {
        return [];
      }

      return List<String>.from(jsonDecode(value) as List);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to retrieve certificate pins',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Efface toutes les données sécurisées
  Future<void> clearAllSecureData() async {
    try {
      await _storage.deleteAll(
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      _logger.warning('All secure data cleared');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to clear secure data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Vérifie si le stockage sécurisé est disponible
  Future<bool> isAvailable() async {
    try {
      // Test d'écriture/lecture
      const testKey = 'secure_storage_test';
      await _storage.write(
        key: testKey,
        value: 'test',
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      final value = await _storage.read(
        key: testKey,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      await _storage.delete(
        key: testKey,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      return value == 'test';
    } on Exception catch (e) {
      _logger.error('Secure storage availability check failed', error: e);
      return false;
    }
  }
}

/// Modèle pour les données de secret TOTP
@immutable
class TOTPSecretData {
  const TOTPSecretData({
    required this.secret,
    required this.createdAt,
    this.metadata,
  });

  factory TOTPSecretData.fromJson(Map<String, dynamic> json) {
    return TOTPSecretData(
      secret: json['secret'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  final String secret;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'secret': secret,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// Provider pour le service de stockage sécurisé
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(
    logger: ref.watch(loggerServiceProvider),
  );
});
