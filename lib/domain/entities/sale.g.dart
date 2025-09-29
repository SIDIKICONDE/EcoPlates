// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sale _$SaleFromJson(Map<String, dynamic> json) => _Sale(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  customerId: json['customerId'] as String,
  customerName: json['customerName'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toDouble(),
  finalAmount: (json['finalAmount'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  collectedAt: json['collectedAt'] == null
      ? null
      : DateTime.parse(json['collectedAt'] as String),
  status: $enumDecode(_$SaleStatusEnumMap, json['status']),
  paymentMethod: json['paymentMethod'] as String,
  paymentTransactionId: json['paymentTransactionId'] as String?,
  secureQrEnabled: json['secureQrEnabled'] as bool? ?? false,
  totpSecretId: json['totpSecretId'] as String?,
  notes: json['notes'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$SaleToJson(_Sale instance) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'items': instance.items,
  'totalAmount': instance.totalAmount,
  'discountAmount': instance.discountAmount,
  'finalAmount': instance.finalAmount,
  'createdAt': instance.createdAt.toIso8601String(),
  'collectedAt': instance.collectedAt?.toIso8601String(),
  'status': _$SaleStatusEnumMap[instance.status]!,
  'paymentMethod': instance.paymentMethod,
  'paymentTransactionId': instance.paymentTransactionId,
  'secureQrEnabled': instance.secureQrEnabled,
  'totpSecretId': instance.totpSecretId,
  'notes': instance.notes,
  'metadata': instance.metadata,
};

const _$SaleStatusEnumMap = {
  SaleStatus.pending: 'pending',
  SaleStatus.confirmed: 'confirmed',
  SaleStatus.collected: 'collected',
  SaleStatus.cancelled: 'cancelled',
  SaleStatus.refunded: 'refunded',
};

_SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => _SaleItem(
  offerId: json['offerId'] as String,
  offerTitle: json['offerTitle'] as String,
  category: $enumDecode(_$FoodCategoryEnumMap, json['category']),
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
);

Map<String, dynamic> _$SaleItemToJson(_SaleItem instance) => <String, dynamic>{
  'offerId': instance.offerId,
  'offerTitle': instance.offerTitle,
  'category': _$FoodCategoryEnumMap[instance.category]!,
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'totalPrice': instance.totalPrice,
};

const _$FoodCategoryEnumMap = {
  FoodCategory.petitDejeuner: 'petitDejeuner',
  FoodCategory.dejeuner: 'dejeuner',
  FoodCategory.diner: 'diner',
  FoodCategory.snack: 'snack',
  FoodCategory.dessert: 'dessert',
  FoodCategory.boisson: 'boisson',
  FoodCategory.boulangerie: 'boulangerie',
  FoodCategory.fruitLegume: 'fruitLegume',
  FoodCategory.epicerie: 'epicerie',
  FoodCategory.autre: 'autre',
};
