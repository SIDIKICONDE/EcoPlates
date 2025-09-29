import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../providers/api_providers.dart';
import 'logger_service.dart';
import 'qr_security_config_service.dart';

/// Service de détection de fraude pour le système QR
class QRFraudDetectionService {
  QRFraudDetectionService({
    required Dio dio,
    required QRSecurityConfigService configService,
    LoggerService? logger,
  }) : _dio = dio,
       _configService = configService,
       _logger =
           logger ??
           LoggerService(
             defaultTag: 'QRFraudDetectionService',
             outputs: [ConsoleLogOutput().log],
           );

  final Dio _dio;
  final QRSecurityConfigService _configService;
  final LoggerService _logger;

  // Cache des tentatives échouées
  final Map<String, List<FailedAttempt>> _failedAttempts = {};

  // Cache des alertes actives
  final Map<String, FraudAlert> _activeAlerts = {};

  // Compteurs pour analytics
  final Map<String, AttemptCounter> _attemptCounters = {};

  /// Enregistre une tentative échouée
  Future<FraudDetectionResult> recordFailedAttempt({
    required String orderId,
    required String deviceId,
    required String failureReason,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) async {
    final config = await _configService.getConfiguration();
    final attempt = FailedAttempt(
      orderId: orderId,
      deviceId: deviceId,
      failureReason: failureReason,
      timestamp: DateTime.now(),
      ipAddress: ipAddress,
      metadata: metadata,
    );

    // Ajouter à la liste des tentatives
    _failedAttempts.putIfAbsent(orderId, () => []).add(attempt);

    // Mettre à jour les compteurs
    _updateCounters(orderId, deviceId);

    // Analyser les patterns de fraude
    final analysis = _analyzePattern(orderId, deviceId, config);

    // Si fraude détectée, créer une alerte
    if (analysis.isSuspicious) {
      final alert = await _createFraudAlert(
        orderId: orderId,
        deviceId: deviceId,
        pattern: analysis.pattern,
        severity: analysis.severity,
      );

      _activeAlerts[orderId] = alert;

      // Notifier le serveur
      await _notifyServer(alert);
    }

    return FraudDetectionResult(
      isSuspicious: analysis.isSuspicious,
      shouldBlock: analysis.shouldBlock,
      pattern: analysis.pattern,
      severity: analysis.severity,
      attemptCount: _getAttemptCount(orderId),
      recommendation: analysis.recommendation,
    );
  }

  /// Analyse les patterns de fraude
  FraudAnalysis _analyzePattern(
    String orderId,
    String deviceId,
    QRSecurityConfig config,
  ) {
    final attempts = _failedAttempts[orderId] ?? [];
    final recentAttempts = _getRecentAttempts(
      attempts,
      const Duration(minutes: 5),
    );

    // Patterns de fraude détectés
    final patterns = <FraudPattern>[];

    // 1. Trop de tentatives rapides
    if (recentAttempts.length >= config.alertThreshold) {
      patterns.add(FraudPattern.rapidAttempts);
    }

    // 2. Multiples devices
    final uniqueDevices = recentAttempts.map((a) => a.deviceId).toSet();
    if (uniqueDevices.length > 2) {
      patterns.add(FraudPattern.multipleDevices);
    }

    // 3. Multiples IPs
    final uniqueIps = recentAttempts
        .where((a) => a.ipAddress != null)
        .map((a) => a.ipAddress!)
        .toSet();
    if (uniqueIps.length > 3) {
      patterns.add(FraudPattern.multipleIPs);
    }

    // 4. Patterns de timing suspects
    if (_hasTimingAnomaly(recentAttempts)) {
      patterns.add(FraudPattern.timingAnomaly);
    }

    // 5. Tentatives après expiration
    final expiredAttempts = recentAttempts
        .where((a) => a.failureReason == 'EXPIRED_TOKEN')
        .length;
    if (expiredAttempts > 2) {
      patterns.add(FraudPattern.expiredTokenAbuse);
    }

    // Déterminer la sévérité
    final severity = _calculateSeverity(patterns, recentAttempts.length);

    // Décider si bloquer
    final shouldBlock =
        recentAttempts.length >= config.maxFailedAttempts ||
        severity == FraudSeverity.critical;

    return FraudAnalysis(
      isSuspicious: patterns.isNotEmpty,
      shouldBlock: shouldBlock,
      pattern: patterns.isNotEmpty ? patterns.first : null,
      severity: severity,
      recommendation: _getRecommendation(patterns, severity),
    );
  }

  /// Détecte les anomalies de timing
  bool _hasTimingAnomaly(List<FailedAttempt> attempts) {
    if (attempts.length < 3) return false;

    // Vérifier si les tentatives sont trop régulières (bot)
    final intervals = <Duration>[];
    for (var i = 1; i < attempts.length; i++) {
      intervals.add(
        attempts[i].timestamp.difference(attempts[i - 1].timestamp),
      );
    }

    // Si tous les intervalles sont similaires (±2 secondes), c'est suspect
    final avgInterval = intervals.reduce((a, b) => a + b) ~/ intervals.length;
    final isTooRegular = intervals.every((interval) {
      final diff = (interval - avgInterval).inSeconds.abs();
      return diff <= 2;
    });

    return isTooRegular;
  }

  /// Calcule la sévérité de la menace
  FraudSeverity _calculateSeverity(
    List<FraudPattern> patterns,
    int attemptCount,
  ) {
    if (patterns.contains(FraudPattern.multipleDevices) &&
        patterns.contains(FraudPattern.rapidAttempts)) {
      return FraudSeverity.critical;
    }

    if (patterns.length >= 2 || attemptCount >= 5) {
      return FraudSeverity.high;
    }

    if (patterns.isNotEmpty || attemptCount >= 3) {
      return FraudSeverity.medium;
    }

    return FraudSeverity.low;
  }

  /// Obtient une recommandation d'action
  String _getRecommendation(
    List<FraudPattern> patterns,
    FraudSeverity severity,
  ) {
    if (severity == FraudSeverity.critical) {
      return "Bloquer immédiatement et vérifier l'identité du client";
    }

    if (patterns.contains(FraudPattern.multipleDevices)) {
      return 'Vérifier si le client utilise plusieurs appareils légitimement';
    }

    if (patterns.contains(FraudPattern.rapidAttempts)) {
      return 'Ralentir les tentatives avec un délai progressif';
    }

    if (patterns.contains(FraudPattern.expiredTokenAbuse)) {
      return 'Le client semble avoir des problèmes de synchronisation';
    }

    return 'Surveiller les prochaines tentatives';
  }

  /// Crée une alerte de fraude
  Future<FraudAlert> _createFraudAlert({
    required String orderId,
    required String deviceId,
    required FraudPattern? pattern,
    required FraudSeverity severity,
  }) async {
    final alert = FraudAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: orderId,
      deviceId: deviceId,
      pattern: pattern,
      severity: severity,
      createdAt: DateTime.now(),
      attemptCount: _getAttemptCount(orderId),
      metadata: {
        'failed_attempts': _failedAttempts[orderId]?.length ?? 0,
        'unique_devices': _getUniqueDeviceCount(orderId),
      },
    );

    _logger.warning(
      'Fraud alert created for order $orderId: ${pattern?.name ?? 'unknown'} (${severity.name})',
    );

    return alert;
  }

  /// Notifie le serveur d'une alerte
  Future<void> _notifyServer(FraudAlert alert) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/qr/fraud/alert',
        data: alert.toJson(),
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to notify server of fraud alert',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Met à jour les compteurs
  void _updateCounters(String orderId, String deviceId) {
    final key = '$orderId:$deviceId';
    _attemptCounters.putIfAbsent(key, AttemptCounter.new).increment();
  }

  /// Obtient le nombre de tentatives
  int _getAttemptCount(String orderId) {
    return _failedAttempts[orderId]?.length ?? 0;
  }

  /// Obtient le nombre d'appareils uniques
  int _getUniqueDeviceCount(String orderId) {
    final attempts = _failedAttempts[orderId] ?? [];
    return attempts.map((a) => a.deviceId).toSet().length;
  }

  /// Obtient les tentatives récentes
  List<FailedAttempt> _getRecentAttempts(
    List<FailedAttempt> attempts,
    Duration window,
  ) {
    final cutoff = DateTime.now().subtract(window);
    return attempts.where((a) => a.timestamp.isAfter(cutoff)).toList();
  }

  /// Nettoie les anciennes données
  void cleanup() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));

    // Nettoyer les tentatives
    _failedAttempts.removeWhere((orderId, attempts) {
      attempts.removeWhere((a) => a.timestamp.isBefore(cutoff));
      return attempts.isEmpty;
    });

    // Nettoyer les alertes
    _activeAlerts.removeWhere((orderId, alert) {
      return alert.createdAt.isBefore(cutoff);
    });

    _logger.info('Fraud detection cleanup completed');
  }

  /// Obtient les statistiques de fraude
  FraudStatistics getStatistics() {
    final totalAttempts = _failedAttempts.values.expand((list) => list).length;

    final totalAlerts = _activeAlerts.length;

    final severityDistribution = <FraudSeverity, int>{};
    for (final alert in _activeAlerts.values) {
      severityDistribution[alert.severity] =
          (severityDistribution[alert.severity] ?? 0) + 1;
    }

    return FraudStatistics(
      totalFailedAttempts: totalAttempts,
      totalAlerts: totalAlerts,
      activeOrders: _failedAttempts.length,
      severityDistribution: severityDistribution,
    );
  }
}

/// Modèles de données

@immutable
class FailedAttempt {
  const FailedAttempt({
    required this.orderId,
    required this.deviceId,
    required this.failureReason,
    required this.timestamp,
    this.ipAddress,
    this.metadata,
  });

  final String orderId;
  final String deviceId;
  final String failureReason;
  final DateTime timestamp;
  final String? ipAddress;
  final Map<String, dynamic>? metadata;
}

@immutable
class FraudDetectionResult {
  const FraudDetectionResult({
    required this.isSuspicious,
    required this.shouldBlock,
    required this.pattern,
    required this.severity,
    required this.attemptCount,
    required this.recommendation,
  });

  final bool isSuspicious;
  final bool shouldBlock;
  final FraudPattern? pattern;
  final FraudSeverity severity;
  final int attemptCount;
  final String recommendation;
}

@immutable
class FraudAlert {
  const FraudAlert({
    required this.id,
    required this.orderId,
    required this.deviceId,
    required this.pattern,
    required this.severity,
    required this.createdAt,
    required this.attemptCount,
    required this.metadata,
  });

  final String id;
  final String orderId;
  final String deviceId;
  final FraudPattern? pattern;
  final FraudSeverity severity;
  final DateTime createdAt;
  final int attemptCount;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'deviceId': deviceId,
    'pattern': pattern?.name,
    'severity': severity.name,
    'createdAt': createdAt.toIso8601String(),
    'attemptCount': attemptCount,
    'metadata': metadata,
  };
}

@immutable
class FraudAnalysis {
  const FraudAnalysis({
    required this.isSuspicious,
    required this.shouldBlock,
    required this.pattern,
    required this.severity,
    required this.recommendation,
  });

  final bool isSuspicious;
  final bool shouldBlock;
  final FraudPattern? pattern;
  final FraudSeverity severity;
  final String recommendation;
}

@immutable
class FraudStatistics {
  const FraudStatistics({
    required this.totalFailedAttempts,
    required this.totalAlerts,
    required this.activeOrders,
    required this.severityDistribution,
  });

  final int totalFailedAttempts;
  final int totalAlerts;
  final int activeOrders;
  final Map<FraudSeverity, int> severityDistribution;
}

class AttemptCounter {
  int count = 0;
  DateTime? lastAttempt;

  void increment() {
    count++;
    lastAttempt = DateTime.now();
  }
}

/// Enums

enum FraudPattern {
  rapidAttempts,
  multipleDevices,
  multipleIPs,
  timingAnomaly,
  expiredTokenAbuse,
  replayAttack,
  bruteForce,
}

enum FraudSeverity {
  low,
  medium,
  high,
  critical,
}

/// Providers

final qrFraudDetectionServiceProvider = Provider<QRFraudDetectionService>((
  ref,
) {
  return QRFraudDetectionService(
    dio: ref.watch(dioProvider),
    configService: ref.watch(qrSecurityConfigServiceProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour les statistiques de fraude
final fraudStatisticsProvider = Provider<FraudStatistics>((ref) {
  final service = ref.watch(qrFraudDetectionServiceProvider);
  return service.getStatistics();
});

/// Provider pour nettoyer périodiquement
final fraudCleanupProvider = StreamProvider<void>((ref) async* {
  final service = ref.watch(qrFraudDetectionServiceProvider);

  while (true) {
    await Future<void>.delayed(const Duration(hours: 1));
    service.cleanup();
    yield null;
  }
});
