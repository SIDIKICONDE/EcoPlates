import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../providers/api_providers.dart';
import 'logger_service.dart';

/// Service pour la synchronisation horaire client-serveur
/// Essentiel pour la précision TOTP
class TimeSyncService {
  TimeSyncService({
    required Dio dio,
    required LoggerService logger,
  }) : _dio = dio,
       _logger = logger;

  final Dio _dio;
  final LoggerService _logger;

  // Cache de la différence horaire
  Duration? _timeOffset;
  DateTime? _lastSync;

  // Configuration
  static const Duration _syncInterval = Duration(hours: 1);
  static const int _syncAttempts = 3;
  static const Duration _syncTimeout = Duration(seconds: 5);

  /// Obtient l'heure synchronisée
  DateTime get synchronizedTime {
    final now = DateTime.now();
    if (_timeOffset != null) {
      return now.add(_timeOffset!);
    }
    return now;
  }

  /// Obtient le décalage horaire actuel
  Duration? get currentOffset => _timeOffset;

  /// Vérifie si une synchronisation est nécessaire
  bool get needsSync {
    if (_lastSync == null || _timeOffset == null) return true;
    return DateTime.now().difference(_lastSync!) > _syncInterval;
  }

  /// Synchronise l'horloge avec le serveur
  Future<SyncResult> synchronizeTime() async {
    _logger.info('Starting time synchronization...');

    final results = <TimeSyncMeasurement>[];

    for (var i = 0; i < _syncAttempts; i++) {
      try {
        final measurement = await _measureTimeOffset();
        results.add(measurement);

        // Petit délai entre les mesures
        if (i < _syncAttempts - 1) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      } on Exception catch (e, stackTrace) {
        _logger.error(
          'Time sync attempt ${i + 1} failed',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    if (results.isEmpty) {
      return const SyncResult(
        success: false,
        error: 'All sync attempts failed',
      );
    }

    // Calcul de l'offset médian pour robustesse
    final offsets = results.map((m) => m.offset).toList()..sort();
    final medianOffset = offsets[offsets.length ~/ 2];

    // Validation de la précision
    final maxDeviation = _calculateMaxDeviation(offsets, medianOffset);
    if (maxDeviation > const Duration(seconds: 5)) {
      _logger.warning(
        'High time sync deviation detected: ${maxDeviation.inMilliseconds}ms',
      );
    }

    // Mise à jour du cache
    _timeOffset = medianOffset;
    _lastSync = DateTime.now();

    _logger.info(
      'Time synchronized successfully. Offset: ${medianOffset.inMilliseconds}ms',
    );

    return SyncResult(
      success: true,
      offset: medianOffset,
      accuracy: maxDeviation,
      measurements: results,
    );
  }

  /// Mesure le décalage horaire avec le serveur
  Future<TimeSyncMeasurement> _measureTimeOffset() async {
    final clientTime1 = DateTime.now().millisecondsSinceEpoch;

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/time/sync',
      options: Options(
        sendTimeout: _syncTimeout,
        receiveTimeout: _syncTimeout,
      ),
    );

    final clientTime2 = DateTime.now().millisecondsSinceEpoch;
    final data = response.data;
    if (data == null) {
      throw Exception('Server response data is null');
    }

    final timestamp = data['timestamp'];
    if (timestamp == null) {
      throw Exception('Server response missing timestamp');
    }

    final serverTime = timestamp as int;

    // Calcul du temps de round-trip
    final roundTripTime = clientTime2 - clientTime1;

    // Estimation du temps serveur au moment de la requête
    final estimatedServerTime = serverTime - (roundTripTime ~/ 2);

    // Calcul de l'offset
    final offset = Duration(
      milliseconds: estimatedServerTime - clientTime1,
    );

    return TimeSyncMeasurement(
      offset: offset,
      roundTripTime: Duration(milliseconds: roundTripTime),
      serverTime: DateTime.fromMillisecondsSinceEpoch(serverTime),
      measurementTime: DateTime.fromMillisecondsSinceEpoch(clientTime1),
    );
  }

  /// Calcule la déviation maximale des mesures
  Duration _calculateMaxDeviation(List<Duration> offsets, Duration median) {
    var maxDeviation = Duration.zero;

    for (final offset in offsets) {
      final deviation = (offset - median).abs();
      if (deviation > maxDeviation) {
        maxDeviation = deviation;
      }
    }

    return maxDeviation;
  }

  /// Invalide le cache de synchronisation
  void invalidateSync() {
    _timeOffset = null;
    _lastSync = null;
    _logger.info('Time sync cache invalidated');
  }

  /// Démarre la synchronisation automatique
  Stream<SyncResult> startAutoSync() async* {
    while (true) {
      if (needsSync) {
        yield await synchronizeTime();
      }

      await Future<void>.delayed(_syncInterval);
    }
  }

  /// Applique un ajustement manuel (pour tests/debug)
  @visibleForTesting
  void applyManualOffset(Duration offset) {
    _timeOffset = offset;
    _lastSync = DateTime.now();
    _logger.debug('Manual time offset applied: ${offset.inMilliseconds}ms');
  }
}

/// Résultat d'une synchronisation
@immutable
class SyncResult {
  const SyncResult({
    required this.success,
    this.offset,
    this.accuracy,
    this.error,
    this.measurements,
  });

  final bool success;
  final Duration? offset;
  final Duration? accuracy;
  final String? error;
  final List<TimeSyncMeasurement>? measurements;
}

/// Mesure individuelle de synchronisation
@immutable
class TimeSyncMeasurement {
  const TimeSyncMeasurement({
    required this.offset,
    required this.roundTripTime,
    required this.serverTime,
    required this.measurementTime,
  });

  final Duration offset;
  final Duration roundTripTime;
  final DateTime serverTime;
  final DateTime measurementTime;
}

/// Provider pour le service de synchronisation
final timeSyncServiceProvider = Provider<TimeSyncService>((ref) {
  return TimeSyncService(
    dio: ref.watch(dioProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour l'heure synchronisée
final synchronizedTimeProvider = Provider<DateTime>((ref) {
  final syncService = ref.watch(timeSyncServiceProvider);
  return syncService.synchronizedTime;
});

/// Provider pour la synchronisation automatique
final autoTimeSyncProvider = StreamProvider<SyncResult>((ref) {
  final syncService = ref.watch(timeSyncServiceProvider);
  return syncService.startAutoSync();
});

/// Provider pour l'état de synchronisation
final timeSyncStateProvider = Provider<TimeSyncState>((ref) {
  final syncService = ref.watch(timeSyncServiceProvider);

  return TimeSyncState(
    hasSync: syncService.currentOffset != null,
    offset: syncService.currentOffset,
    needsSync: syncService.needsSync,
  );
});

/// État de la synchronisation horaire
@immutable
class TimeSyncState {
  const TimeSyncState({
    required this.hasSync,
    required this.needsSync,
    this.offset,
  });

  final bool hasSync;
  final bool needsSync;
  final Duration? offset;

  String get displayOffset {
    if (offset == null) return 'Non synchronisé';

    final ms = offset!.inMilliseconds.abs();
    final sign = offset!.isNegative ? '-' : '+';

    if (ms < 1000) {
      return '$sign${ms}ms';
    } else {
      return '$sign${(ms / 1000).toStringAsFixed(1)}s';
    }
  }
}
