import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../providers/api_providers.dart';
import 'logger_service.dart';

/// Service de configuration pour la sécurité QR
/// Permet une configuration flexible côté serveur
class QRSecurityConfigService {
  QRSecurityConfigService({
    required Dio dio,
    LoggerService? logger,
  }) : _dio = dio,
       _logger =
           logger ??
           LoggerService(
             defaultTag: 'QRSecurityConfigService',
             outputs: [ConsoleLogOutput().log],
           );

  final Dio _dio;
  final LoggerService _logger;

  // Cache de configuration
  QRSecurityConfig? _cachedConfig;
  DateTime? _lastConfigFetch;

  // Configuration par défaut
  static const _defaultConfig = QRSecurityConfig(
    totpWindowSteps: 1,
    totpPeriodSeconds: 30,
    totpDigits: 8,
    maxOfflineHours: 24,
    qrExpirationSeconds: 30,
    enableDeviceBinding: false,
    enableGranularRevocation: false,
    maxFailedAttempts: 5,
    alertThreshold: 3,
    compressionEnabled: true,
    protocolVersion: '2.0',
  );

  /// Obtient la configuration actuelle
  Future<QRSecurityConfig> getConfiguration() async {
    // Utiliser le cache si valide
    if (_cachedConfig != null && _isConfigCacheValid()) {
      return _cachedConfig!;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/qr/config',
      );
      final config = QRSecurityConfig.fromJson(response.data!);

      // Mettre à jour le cache
      _cachedConfig = config;
      _lastConfigFetch = DateTime.now();

      _logger.info('QR security config updated from server');
      return config;
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch QR security config, using defaults',
        error: e,
        stackTrace: stackTrace,
      );

      // Retourner config par défaut ou cache en cas d'erreur
      return _cachedConfig ?? _defaultConfig;
    }
  }

  /// Vérifie si le cache de config est valide
  bool _isConfigCacheValid() {
    if (_lastConfigFetch == null) return false;

    final age = DateTime.now().difference(_lastConfigFetch!);
    return age < const Duration(hours: 1);
  }

  /// Force une mise à jour de la configuration
  Future<void> refreshConfiguration() async {
    _cachedConfig = null;
    _lastConfigFetch = null;
    await getConfiguration();
  }

  /// Obtient les limites de génération hors-ligne
  OfflineLimits getOfflineLimits(QRSecurityConfig config) {
    return OfflineLimits(
      maxDuration: Duration(hours: config.maxOfflineHours),
      maxGenerations:
          (config.maxOfflineHours * 3600) ~/ config.totpPeriodSeconds,
      warningThreshold: Duration(hours: config.maxOfflineHours ~/ 2),
    );
  }

  /// Vérifie si un appareil peut générer des QR hors-ligne
  bool canGenerateOffline(DateTime lastOnline, QRSecurityConfig config) {
    final offlineDuration = DateTime.now().difference(lastOnline);
    final limits = getOfflineLimits(config);
    return offlineDuration < limits.maxDuration;
  }
}

/// Configuration de sécurité QR
@immutable
class QRSecurityConfig {
  const QRSecurityConfig({
    required this.totpWindowSteps,
    required this.totpPeriodSeconds,
    required this.totpDigits,
    required this.maxOfflineHours,
    required this.qrExpirationSeconds,
    required this.enableDeviceBinding,
    required this.enableGranularRevocation,
    required this.maxFailedAttempts,
    required this.alertThreshold,
    required this.compressionEnabled,
    required this.protocolVersion,
    this.customSettings = const {},
  });

  factory QRSecurityConfig.fromJson(Map<String, dynamic> json) {
    return QRSecurityConfig(
      totpWindowSteps: (json['totpWindowSteps'] as int?) ?? 1,
      totpPeriodSeconds: (json['totpPeriodSeconds'] as int?) ?? 30,
      totpDigits: (json['totpDigits'] as int?) ?? 8,
      maxOfflineHours: (json['maxOfflineHours'] as int?) ?? 24,
      qrExpirationSeconds: (json['qrExpirationSeconds'] as int?) ?? 30,
      enableDeviceBinding: (json['enableDeviceBinding'] as bool?) ?? false,
      enableGranularRevocation:
          (json['enableGranularRevocation'] as bool?) ?? false,
      maxFailedAttempts: (json['maxFailedAttempts'] as int?) ?? 5,
      alertThreshold: (json['alertThreshold'] as int?) ?? 3,
      compressionEnabled: (json['compressionEnabled'] as bool?) ?? true,
      protocolVersion: (json['protocolVersion'] as String?) ?? '2.0',
      customSettings: Map<String, dynamic>.from(
        json['customSettings'] as Map? ?? {},
      ),
    );
  }

  // Paramètres TOTP
  final int totpWindowSteps; // Fenêtre de tolérance (±n steps)
  final int totpPeriodSeconds; // Période de rotation
  final int totpDigits; // Nombre de chiffres du token

  // Limites hors-ligne
  final int maxOfflineHours; // Durée max de génération hors-ligne
  final int qrExpirationSeconds; // Durée de vie d'un QR

  // Sécurité avancée
  final bool enableDeviceBinding; // Lier QR à un device spécifique
  final bool enableGranularRevocation; // Révocation par device

  // Détection de fraude
  final int maxFailedAttempts; // Max tentatives avant blocage
  final int alertThreshold; // Seuil pour alertes automatiques

  // Optimisations
  final bool compressionEnabled; // Compression payload
  final String protocolVersion; // Version du protocole

  // Paramètres personnalisés
  final Map<String, dynamic> customSettings;

  /// Obtient la fenêtre de tolérance en Duration
  Duration get toleranceWindow => Duration(
    seconds: totpWindowSteps * totpPeriodSeconds,
  );

  Map<String, dynamic> toJson() {
    return {
      'totpWindowSteps': totpWindowSteps,
      'totpPeriodSeconds': totpPeriodSeconds,
      'totpDigits': totpDigits,
      'maxOfflineHours': maxOfflineHours,
      'qrExpirationSeconds': qrExpirationSeconds,
      'enableDeviceBinding': enableDeviceBinding,
      'enableGranularRevocation': enableGranularRevocation,
      'maxFailedAttempts': maxFailedAttempts,
      'alertThreshold': alertThreshold,
      'compressionEnabled': compressionEnabled,
      'protocolVersion': protocolVersion,
      'customSettings': customSettings,
    };
  }
}

/// Limites de génération hors-ligne
@immutable
class OfflineLimits {
  const OfflineLimits({
    required this.maxDuration,
    required this.maxGenerations,
    required this.warningThreshold,
  });

  final Duration maxDuration;
  final int maxGenerations;
  final Duration warningThreshold;

  bool get isNearLimit {
    final remaining = maxDuration - warningThreshold;
    return remaining < const Duration(hours: 12);
  }
}

/// Provider pour le service de configuration
final qrSecurityConfigServiceProvider = Provider<QRSecurityConfigService>((
  ref,
) {
  return QRSecurityConfigService(
    dio: ref.watch(dioProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour la configuration actuelle
final qrSecurityConfigProvider = FutureProvider<QRSecurityConfig>((ref) async {
  final service = ref.watch(qrSecurityConfigServiceProvider);
  return service.getConfiguration();
});

/// Provider pour les limites hors-ligne
final offlineLimitsProvider = Provider<OfflineLimits?>((ref) {
  final configAsync = ref.watch(qrSecurityConfigProvider);

  return configAsync.whenOrNull(
    data: (config) {
      final service = ref.watch(qrSecurityConfigServiceProvider);
      return service.getOfflineLimits(config);
    },
  );
});
