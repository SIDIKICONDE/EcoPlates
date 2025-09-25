// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockItemModel _$StockItemModelFromJson(Map<String, dynamic> json) =>
    StockItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      unit: json['unit'] as String,
      status: $enumDecode(_$StockItemStatusEnumMap, json['status']),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$StockItemModelToJson(StockItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'category': instance.category,
      'price': instance.price,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'status': _$StockItemStatusEnumMap[instance.status]!,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
    };

const _$StockItemStatusEnumMap = {
  StockItemStatus.active: 'active',
  StockItemStatus.inactive: 'inactive',
};
