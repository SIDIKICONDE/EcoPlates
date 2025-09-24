// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockMovementModelAdapter extends TypeAdapter<StockMovementModel> {
  @override
  final int typeId = 13;

  @override
  StockMovementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockMovementModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      merchantId: fields[2] as String,
      type: fields[3] as String,
      quantity: fields[4] as double,
      stockBefore: fields[5] as double,
      stockAfter: fields[6] as double,
      reason: fields[7] as String?,
      referenceId: fields[8] as String?,
      userId: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      metadata: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StockMovementModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.merchantId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.stockBefore)
      ..writeByte(6)
      ..write(obj.stockAfter)
      ..writeByte(7)
      ..write(obj.reason)
      ..writeByte(8)
      ..write(obj.referenceId)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockMovementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) =>
    StockMovementModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      merchantId: json['merchantId'] as String,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      stockBefore: (json['stockBefore'] as num).toDouble(),
      stockAfter: (json['stockAfter'] as num).toDouble(),
      reason: json['reason'] as String?,
      referenceId: json['referenceId'] as String?,
      userId: json['userId'] as String?,
      createdAt: StockMovementModel._dateTimeFromJson(json['createdAt']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StockMovementModelToJson(StockMovementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'merchantId': instance.merchantId,
      'type': instance.type,
      'quantity': instance.quantity,
      'stockBefore': instance.stockBefore,
      'stockAfter': instance.stockAfter,
      'reason': instance.reason,
      'referenceId': instance.referenceId,
      'userId': instance.userId,
      'createdAt': StockMovementModel._dateTimeToJson(instance.createdAt),
      'metadata': instance.metadata,
    };
