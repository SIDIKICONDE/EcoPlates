import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/stock_movement.dart';

part 'stock_movement_model.g.dart';

/// Modèle de données pour StockMovement avec sérialisation JSON
@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 13)
class StockMovementModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String productId;
  
  @HiveField(2)
  final String merchantId;
  
  @HiveField(3)
  final String type;
  
  @HiveField(4)
  final double quantity;
  
  @HiveField(5)
  final double stockBefore;
  
  @HiveField(6)
  final double stockAfter;
  
  @HiveField(7)
  final String? reason;
  
  @HiveField(8)
  final String? referenceId;
  
  @HiveField(9)
  final String? userId;
  
  @HiveField(10)
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  
  @HiveField(11)
  final Map<String, dynamic>? metadata;

  const StockMovementModel({
    required this.id,
    required this.productId,
    required this.merchantId,
    required this.type,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    this.reason,
    this.referenceId,
    this.userId,
    required this.createdAt,
    this.metadata,
  });

  /// Convertit depuis l'entité du domaine
  factory StockMovementModel.fromDomain(StockMovement movement) {
    return StockMovementModel(
      id: movement.id,
      productId: movement.productId,
      merchantId: movement.merchantId,
      type: movement.type.name,
      quantity: movement.quantity,
      stockBefore: movement.stockBefore,
      stockAfter: movement.stockAfter,
      reason: movement.reason,
      referenceId: movement.referenceId,
      userId: movement.userId,
      createdAt: movement.createdAt,
      metadata: movement.metadata,
    );
  }

  /// Convertit vers l'entité du domaine
  StockMovement toDomain() {
    return StockMovement(
      id: id,
      productId: productId,
      merchantId: merchantId,
      type: MovementType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MovementType.manualAdjustment,
      ),
      quantity: quantity,
      stockBefore: stockBefore,
      stockAfter: stockAfter,
      reason: reason,
      referenceId: referenceId,
      userId: userId,
      createdAt: createdAt,
      metadata: metadata,
    );
  }

  factory StockMovementModel.fromJson(Map<String, dynamic> json) =>
      _$StockMovementModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockMovementModelToJson(this);

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }

  static dynamic _dateTimeToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}