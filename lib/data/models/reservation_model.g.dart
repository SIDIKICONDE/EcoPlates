// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    ReservationModel(
      id: json['id'] as String,
      offerId: json['offerId'] as String,
      userId: json['userId'] as String,
      merchantId: json['merchantId'] as String,
      reservedAt: DateTime.parse(json['reservedAt'] as String),
      pickupStartTime: DateTime.parse(json['pickupStartTime'] as String),
      pickupEndTime: DateTime.parse(json['pickupEndTime'] as String),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      cancellationReason: json['cancellationReason'] as String?,
      collectedAt: json['collectedAt'] == null
          ? null
          : DateTime.parse(json['collectedAt'] as String),
      confirmationCode: json['confirmationCode'] as String,
      paymentInfo: json['paymentInfo'] == null
          ? null
          : PaymentInfoModel.fromJson(
              json['paymentInfo'] as Map<String, dynamic>,
            ),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ReservationModelToJson(ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'offerId': instance.offerId,
      'userId': instance.userId,
      'merchantId': instance.merchantId,
      'reservedAt': instance.reservedAt.toIso8601String(),
      'pickupStartTime': instance.pickupStartTime.toIso8601String(),
      'pickupEndTime': instance.pickupEndTime.toIso8601String(),
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'cancellationReason': instance.cancellationReason,
      'collectedAt': instance.collectedAt?.toIso8601String(),
      'confirmationCode': instance.confirmationCode,
      'paymentInfo': instance.paymentInfo?.toJson(),
      'quantity': instance.quantity,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.collected: 'collected',
  ReservationStatus.cancelled: 'cancelled',
  ReservationStatus.noShow: 'noShow',
  ReservationStatus.expired: 'expired',
};

PaymentInfoModel _$PaymentInfoModelFromJson(Map<String, dynamic> json) =>
    PaymentInfoModel(
      paymentId: json['paymentId'] as String,
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      amount: (json['amount'] as num).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$PaymentInfoModelToJson(PaymentInfoModel instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'amount': instance.amount,
      'paidAt': instance.paidAt.toIso8601String(),
      'status': _$PaymentStatusEnumMap[instance.status]!,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.card: 'card',
  PaymentMethod.paypal: 'paypal',
  PaymentMethod.applePay: 'applePay',
  PaymentMethod.googlePay: 'googlePay',
  PaymentMethod.free: 'free',
  PaymentMethod.cash: 'cash',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.notRequired: 'notRequired',
};
