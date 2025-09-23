import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/reservation.dart';

part 'reservation_model.g.dart';

/// Modèle de données pour Reservation avec sérialisation JSON
@JsonSerializable(explicitToJson: true)
class ReservationModel {
  final String id;
  final String offerId;
  final String userId;
  final String merchantId;
  final DateTime reservedAt;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final ReservationStatus status;
  final String? cancellationReason;
  final DateTime? collectedAt;
  final String confirmationCode;
  final PaymentInfoModel? paymentInfo;
  final int quantity;

  const ReservationModel({
    required this.id,
    required this.offerId,
    required this.userId,
    required this.merchantId,
    required this.reservedAt,
    required this.pickupStartTime,
    required this.pickupEndTime,
    required this.status,
    this.cancellationReason,
    this.collectedAt,
    required this.confirmationCode,
    this.paymentInfo,
    this.quantity = 1,
  });

  /// Créer une instance depuis JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  /// Convertir en JSON
  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);

  /// Créer depuis l'entité domaine
  factory ReservationModel.fromEntity(Reservation reservation) {
    return ReservationModel(
      id: reservation.id,
      offerId: reservation.offerId,
      userId: reservation.userId,
      merchantId: reservation.merchantId,
      reservedAt: reservation.reservedAt,
      pickupStartTime: reservation.pickupStartTime,
      pickupEndTime: reservation.pickupEndTime,
      status: reservation.status,
      cancellationReason: reservation.cancellationReason,
      collectedAt: reservation.collectedAt,
      confirmationCode: reservation.confirmationCode,
      paymentInfo: reservation.paymentInfo != null
          ? PaymentInfoModel.fromEntity(reservation.paymentInfo!)
          : null,
      quantity: reservation.quantity,
    );
  }

  /// Convertir vers l'entité domaine
  Reservation toEntity() {
    return Reservation(
      id: id,
      offerId: offerId,
      userId: userId,
      merchantId: merchantId,
      reservedAt: reservedAt,
      pickupStartTime: pickupStartTime,
      pickupEndTime: pickupEndTime,
      status: status,
      cancellationReason: cancellationReason,
      collectedAt: collectedAt,
      confirmationCode: confirmationCode,
      paymentInfo: paymentInfo != null
          ? PaymentInfo(
              paymentId: paymentInfo!.paymentId,
              method: paymentInfo!.method,
              amount: paymentInfo!.amount,
              paidAt: paymentInfo!.paidAt,
              status: paymentInfo!.status,
            )
          : null,
      quantity: quantity,
    );
  }
}

/// Modèle pour PaymentInfo avec sérialisation JSON
@JsonSerializable()
class PaymentInfoModel {
  final String paymentId;
  final PaymentMethod method;
  final double amount;
  final DateTime paidAt;
  final PaymentStatus status;

  const PaymentInfoModel({
    required this.paymentId,
    required this.method,
    required this.amount,
    required this.paidAt,
    required this.status,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoModelToJson(this);

  factory PaymentInfoModel.fromEntity(PaymentInfo payment) {
    return PaymentInfoModel(
      paymentId: payment.paymentId,
      method: payment.method,
      amount: payment.amount,
      paidAt: payment.paidAt,
      status: payment.status,
    );
  }
}
