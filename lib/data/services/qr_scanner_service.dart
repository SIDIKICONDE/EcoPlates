import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reservation_service.dart';

/// Service pour gérer le scanning de QR codes (commandes/réservations)
class QrScannerService {
  /// Traite le QR code scanné et retourne l'action à effectuer (validation commande)
  Future<QrScanResult> processQrCode(String qrData) async {
    try {
      // Valider le format du QR code de commande
      if (!_isValidQrFormat(qrData)) {
        return QrScanResult.error('QR Code invalide');
      }

      // Parser les données du QR code (commande/réservation)
      final data = _parseQrData(qrData);

      // Vérifier côté serveur que le code de confirmation est valide pour la réservation
      final reservationService = ReservationService();
      final isValid = await reservationService.verifyReservation(
        data['confirmationCode']!,
      );

      if (!isValid) {
        return QrScanResult.error('Code de confirmation invalide ou expiré');
      }

      // Si valide: proposer la collecte (validation de commande)
      return QrScanResult.collect(
        reservationId: data['reservationId']!,
        confirmationCode: data['confirmationCode']!,
      );
    } catch (e) {
      return QrScanResult.error('Erreur lors du traitement: $e');
    }
  }

  /// Valide le format du QR code de commande
  bool _isValidQrFormat(String qrData) {
    // Formats acceptés:
    // - ECOPLATES:RESERVATION:<RES_ID>:<CONFIRMATION_CODE>
    // - ECOPLATES:ORDER:<RES_ID>:<CONFIRMATION_CODE>
    final parts = qrData.split(':');
    if (parts.length < 4) return false;
    if (parts[0] != 'ECOPLATES') return false;
    final kind = parts[1];
    return kind == 'RESERVATION' || kind == 'ORDER';
  }

  /// Parse les données du QR code de commande
  Map<String, String?> _parseQrData(String qrData) {
    final parts = qrData.split(':');
    return {
      'type': parts[1],
      'reservationId': parts[2],
      'confirmationCode': parts[3],
    };
  }

  /// Valide une commande (réservation) - réservé aux commerçants
  Future<bool> confirmOrder(String reservationId, String confirmationCode) async {
    try {
      final reservationService = ReservationService();
      await reservationService.confirmCollection(reservationId, confirmationCode);
      return true;
    } catch (e) {
      throw Exception('Erreur lors de la validation: $e');
    }
  }
}

/// Résultat du scan QR
class QrScanResult {
  final QrScanAction action;
  // Champs historiques (assiettes) conservés pour compatibilité éventuelle
  final String? plateId;
  final String? plateCode;
  final String? location;
  // Nouveaux champs pour commandes/réservations
  final String? reservationId;
  final String? confirmationCode;
  final String? message;
  final bool isError;

  QrScanResult._({
    required this.action,
    this.plateId,
    this.plateCode,
    this.location,
    this.reservationId,
    this.confirmationCode,
    this.message,
    this.isError = false,
  });

  // Usages historiques (assiettes)
  factory QrScanResult.borrow({
    required String plateId,
    required String plateCode,
    required String location,
  }) {
    return QrScanResult._(
      action: QrScanAction.borrow,
      plateId: plateId,
      plateCode: plateCode,
      location: location,
    );
  }

  factory QrScanResult.returnPlate({
    required String plateId,
    required String plateCode,
    required String location,
  }) {
    return QrScanResult._(
      action: QrScanAction.returnPlate,
      plateId: plateId,
      plateCode: plateCode,
      location: location,
    );
  }

  // Nouveau: validation de commande (collecte réservation)
  factory QrScanResult.collect({
    required String reservationId,
    required String confirmationCode,
  }) {
    return QrScanResult._(
      action: QrScanAction.collect,
      reservationId: reservationId,
      confirmationCode: confirmationCode,
    );
  }

  factory QrScanResult.info({
    required String plateId,
    required String message,
  }) {
    return QrScanResult._(
      action: QrScanAction.info,
      plateId: plateId,
      message: message,
    );
  }

  factory QrScanResult.error(String message) {
    return QrScanResult._(
      action: QrScanAction.error,
      message: message,
      isError: true,
    );
  }
}

/// Actions possibles suite au scan
enum QrScanAction {
  borrow,
  returnPlate,
  collect, // validation d'une commande (réservation)
  info,
  error,
}

/// Historique d'une assiette (conservé si nécessaire)
class PlateHistory {
  final String plateId;
  final PlateAction action;
  final DateTime timestamp;
  final String location;

  PlateHistory({
    required this.plateId,
    required this.action,
    required this.timestamp,
    required this.location,
  });
}

/// Actions sur une assiette (conservé si nécessaire)
enum PlateAction {
  borrowed,
  returned,
}

/// Provider pour le service de scan QR
final qrScannerServiceProvider = Provider<QrScannerService>((ref) {
  return QrScannerService();
});
