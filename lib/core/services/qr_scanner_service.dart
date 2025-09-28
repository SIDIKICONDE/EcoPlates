import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/api_providers.dart';
import 'logger_service.dart';
import 'qr_code_service.dart';

/// Service pour scanner et valider les QR codes côté commerçant
class QRScannerService {
  QRScannerService({
    required QRCodeService qrCodeService,
    required Dio dio,
    LoggerService? logger,
  }) : _qrCodeService = qrCodeService,
       _dio = dio,
       _logger =
           logger ??
           LoggerService(
             defaultTag: 'QRScannerService',
             outputs: [ConsoleLogOutput().log],
           );

  final QRCodeService _qrCodeService;
  final Dio _dio;
  final LoggerService _logger;

  // Cache des scans hors ligne
  final List<OfflineScan> _offlineScans = [];

  /// Traite un QR code scanné
  Future<QRScanResult> processScan(
    String qrData, {
    required String merchantId,
    String? deviceFingerprint,
    Map<String, double>? location,
  }) async {
    try {
      // Validation locale d'abord
      final localValidation = await _qrCodeService.validateQRCodeLocally(
        qrData,
      );
      if (!localValidation.isValid) {
        return QRScanResult(
          success: false,
          error: localValidation.error ?? 'INVALID_QR',
          message: localValidation.message ?? 'QR code invalide',
        );
      }

      // Vérification du merchant ID
      final payload = localValidation.payload!;
      if (payload['merchant_id'] != merchantId) {
        return const QRScanResult(
          success: false,
          error: 'MERCHANT_MISMATCH',
          message: "Ce QR code n'est pas destiné à votre établissement",
        );
      }

      // Tentative de validation serveur
      try {
        final response = await _validateOnServer(
          qrData: qrData,
          deviceFingerprint: deviceFingerprint,
          location: location,
        );

        if ((response.data as Map<String, dynamic>)['valid'] == true) {
          return QRScanResult(
            success: true,
            order: Order.fromJson(
              (response.data as Map<String, dynamic>)['order']
                  as Map<String, dynamic>,
            ),
            validationId:
                (response.data as Map<String, dynamic>)['validationId']
                    as String?,
          );
        } else {
          return QRScanResult(
            success: false,
            error: (response.data as Map<String, dynamic>)['error'] as String?,
            message:
                (response.data as Map<String, dynamic>)['message'] as String?,
          );
        }
      } on Exception catch (e) {
        // En cas d'erreur réseau, stocker pour synchronisation ultérieure
        _logger.warning(
          'Network error during QR validation, storing offline: $e',
        );

        final offlineScan = OfflineScan(
          qrData: qrData,
          merchantId: merchantId,
          deviceFingerprint: deviceFingerprint,
          location: location,
          scannedAt: DateTime.now(),
          payload: payload,
        );

        _offlineScans.add(offlineScan);

        return QRScanResult(
          success: false,
          error: 'OFFLINE',
          message: 'Mode hors ligne - Scan enregistré pour synchronisation',
          isOffline: true,
          offlineScanId: offlineScan.id,
        );
      }
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to process QR scan',
        error: e,
        stackTrace: stackTrace,
      );
      return const QRScanResult(
        success: false,
        error: 'PROCESSING_ERROR',
        message: 'Erreur lors du traitement du QR code',
      );
    }
  }

  /// Valide le QR code sur le serveur
  Future<Response<dynamic>> _validateOnServer({
    required String qrData,
    String? deviceFingerprint,
    Map<String, double>? location,
  }) async {
    return _dio.post(
      '/api/v1/qr/validate',
      data: {
        'qrData': qrData,
        'deviceFingerprint': deviceFingerprint ?? await _getDeviceFingerprint(),
        'scanLocation': location,
      },
      options: Options(
        headers: {
          'X-Device-ID': deviceFingerprint ?? await _getDeviceFingerprint(),
        },
      ),
    );
  }

  /// Synchronise les scans hors ligne
  Future<SyncResult> syncOfflineScans() async {
    if (_offlineScans.isEmpty) {
      return const SyncResult(synced: 0, failed: 0);
    }

    _logger.info('Starting sync of ${_offlineScans.length} offline scans');

    var synced = 0;
    var failed = 0;
    final toRemove = <OfflineScan>[];

    for (final scan in _offlineScans) {
      try {
        // Vérifier si le scan n'est pas trop vieux (24h max)
        if (DateTime.now().difference(scan.scannedAt) >
            const Duration(hours: 24)) {
          toRemove.add(scan);
          failed++;
          continue;
        }

        final response = await _validateOnServer(
          qrData: scan.qrData,
          deviceFingerprint: scan.deviceFingerprint,
          location: scan.location,
        );

        if ((response.data as Map<String, dynamic>)['valid'] == true) {
          synced++;
        } else {
          failed++;
        }

        toRemove.add(scan);
      } on Exception catch (e) {
        _logger.error('Failed to sync offline scan', error: e);
        failed++;
      }
    }

    // Retirer les scans traités
    _offlineScans.removeWhere(toRemove.contains);

    _logger.info('Sync completed: $synced synced, $failed failed');
    return SyncResult(synced: synced, failed: failed);
  }

  /// Obtient le device fingerprint unique
  Future<String> _getDeviceFingerprint() async {
    // TODO: Implémenter une vraie empreinte unique du device
    // Pour l'instant, retourne un ID simple
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Obtient le nombre de scans en attente
  int get pendingScansCount => _offlineScans.length;

  /// Vide le cache des scans hors ligne
  void clearOfflineScans() {
    _offlineScans.clear();
    _logger.info('Cleared offline scans cache');
  }
}

/// Résultat d'un scan QR
@immutable
class QRScanResult {
  const QRScanResult({
    required this.success,
    this.order,
    this.validationId,
    this.error,
    this.message,
    this.isOffline = false,
    this.offlineScanId,
  });

  final bool success;
  final Order? order;
  final String? validationId;
  final String? error;
  final String? message;
  final bool isOffline;
  final String? offlineScanId;
}

/// Modèle simplifié d'une commande
@immutable
class Order {
  const Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }

  final String id;
  final String customerName;
  final List<OrderItem> items;
  final double totalAmount;
}

/// Article d'une commande
@immutable
class OrderItem {
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  final String name;
  final int quantity;
  final double price;
}

/// Scan hors ligne en attente
class OfflineScan {
  OfflineScan({
    required this.qrData,
    required this.merchantId,
    required this.deviceFingerprint,
    required this.location,
    required this.scannedAt,
    required this.payload,
    String? id,
  }) : id = id ?? _generateId();

  final String id;
  final String qrData;
  final String merchantId;
  final String? deviceFingerprint;
  final Map<String, double>? location;
  final DateTime scannedAt;
  final Map<String, dynamic> payload;

  static String _generateId() {
    return 'offline_${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// Résultat de synchronisation
@immutable
class SyncResult {
  const SyncResult({
    required this.synced,
    required this.failed,
  });

  final int synced;
  final int failed;

  int get total => synced + failed;
  bool get hasErrors => failed > 0;
}

/// Provider pour le service de scan QR
final qrScannerServiceProvider = Provider<QRScannerService>((ref) {
  return QRScannerService(
    qrCodeService: ref.watch(qrCodeServiceProvider),
    dio: ref.watch(dioProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

/// Provider pour le controller du scanner
final Provider<MobileScannerController> mobileScannerControllerProvider =
    Provider.autoDispose<MobileScannerController>((ref) {
      final controller = MobileScannerController(
        formats: [BarcodeFormat.qrCode],
      );

      ref.onDispose(controller.dispose);

      return controller;
    });

/// Provider pour l'état des scans hors ligne
final offlineScansCountProvider = Provider<int>((ref) {
  final scanner = ref.watch(qrScannerServiceProvider);
  return scanner.pendingScansCount;
});

/// Provider pour la synchronisation automatique
final StreamProvider<SyncResult> autoSyncProvider =
    StreamProvider.autoDispose<SyncResult>((ref) async* {
      final scanner = ref.watch(qrScannerServiceProvider);

      while (true) {
        // Sync toutes les 30 secondes si des scans sont en attente
        await Future<void>.delayed(const Duration(seconds: 30));

        if (scanner.pendingScansCount > 0) {
          final result = await scanner.syncOfflineScans();
          yield result;

          // Mettre à jour le compteur en invalidant le provider
          ref.invalidate(offlineScansCountProvider);
        }
      }
    });
