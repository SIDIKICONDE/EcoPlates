// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 10;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      merchantId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      barcode: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      category: fields[6] as String,
      price: fields[7] as double,
      costPrice: fields[8] as double?,
      stock: fields[9] as StockModel,
      nutritionalInfo: fields[10] as NutritionalInfoModel?,
      allergens: (fields[11] as List).cast<String>(),
      isVegetarian: fields[12] as bool,
      isVegan: fields[13] as bool,
      isHalal: fields[14] as bool,
      isBio: fields[15] as bool,
      expirationDate: fields[16] as DateTime?,
      unit: fields[17] as String,
      weight: fields[18] as double,
      isActive: fields[19] as bool,
      createdAt: fields[20] as DateTime,
      updatedAt: fields[21] as DateTime,
      customFields: (fields[22] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.merchantId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.costPrice)
      ..writeByte(9)
      ..write(obj.stock)
      ..writeByte(10)
      ..write(obj.nutritionalInfo)
      ..writeByte(11)
      ..write(obj.allergens)
      ..writeByte(12)
      ..write(obj.isVegetarian)
      ..writeByte(13)
      ..write(obj.isVegan)
      ..writeByte(14)
      ..write(obj.isHalal)
      ..writeByte(15)
      ..write(obj.isBio)
      ..writeByte(16)
      ..write(obj.expirationDate)
      ..writeByte(17)
      ..write(obj.unit)
      ..writeByte(18)
      ..write(obj.weight)
      ..writeByte(19)
      ..write(obj.isActive)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(22)
      ..write(obj.customFields);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final int typeId = 11;

  @override
  StockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockModel(
      quantity: fields[0] as double,
      minQuantity: fields[1] as double,
      maxQuantity: fields[2] as double,
      status: fields[3] as String,
      lastRestockDate: fields[4] as DateTime?,
      lastMovementDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.minQuantity)
      ..writeByte(2)
      ..write(obj.maxQuantity)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.lastRestockDate)
      ..writeByte(5)
      ..write(obj.lastMovementDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NutritionalInfoModelAdapter extends TypeAdapter<NutritionalInfoModel> {
  @override
  final int typeId = 12;

  @override
  NutritionalInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionalInfoModel(
      calories: fields[0] as double?,
      proteins: fields[1] as double?,
      carbohydrates: fields[2] as double?,
      sugars: fields[3] as double?,
      fat: fields[4] as double?,
      saturatedFat: fields[5] as double?,
      fiber: fields[6] as double?,
      salt: fields[7] as double?,
      vitamins: (fields[8] as Map?)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, NutritionalInfoModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.calories)
      ..writeByte(1)
      ..write(obj.proteins)
      ..writeByte(2)
      ..write(obj.carbohydrates)
      ..writeByte(3)
      ..write(obj.sugars)
      ..writeByte(4)
      ..write(obj.fat)
      ..writeByte(5)
      ..write(obj.saturatedFat)
      ..writeByte(6)
      ..write(obj.fiber)
      ..writeByte(7)
      ..write(obj.salt)
      ..writeByte(8)
      ..write(obj.vitamins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionalInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      merchantId: json['merchantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      barcode: json['barcode'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      costPrice: (json['costPrice'] as num?)?.toDouble(),
      stock: StockModel.fromJson(json['stock'] as Map<String, dynamic>),
      nutritionalInfo: json['nutritionalInfo'] == null
          ? null
          : NutritionalInfoModel.fromJson(
              json['nutritionalInfo'] as Map<String, dynamic>),
      allergens:
          (json['allergens'] as List<dynamic>).map((e) => e as String).toList(),
      isVegetarian: json['isVegetarian'] as bool,
      isVegan: json['isVegan'] as bool,
      isHalal: json['isHalal'] as bool,
      isBio: json['isBio'] as bool,
      expirationDate:
          ProductModel._dateTimeFromJsonNullable(json['expirationDate']),
      unit: json['unit'] as String,
      weight: (json['weight'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: ProductModel._dateTimeFromJson(json['createdAt']),
      updatedAt: ProductModel._dateTimeFromJson(json['updatedAt']),
      customFields: json['customFields'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'name': instance.name,
      'description': instance.description,
      'barcode': instance.barcode,
      'images': instance.images,
      'category': instance.category,
      'price': instance.price,
      'costPrice': instance.costPrice,
      'stock': instance.stock.toJson(),
      'nutritionalInfo': instance.nutritionalInfo?.toJson(),
      'allergens': instance.allergens,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'isHalal': instance.isHalal,
      'isBio': instance.isBio,
      'expirationDate': ProductModel._dateTimeToJson(instance.expirationDate),
      'unit': instance.unit,
      'weight': instance.weight,
      'isActive': instance.isActive,
      'createdAt': ProductModel._dateTimeToJson(instance.createdAt),
      'updatedAt': ProductModel._dateTimeToJson(instance.updatedAt),
      'customFields': instance.customFields,
    };

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      quantity: (json['quantity'] as num).toDouble(),
      minQuantity: (json['minQuantity'] as num).toDouble(),
      maxQuantity: (json['maxQuantity'] as num).toDouble(),
      status: json['status'] as String,
      lastRestockDate:
          StockModel._dateTimeFromJsonNullable(json['lastRestockDate']),
      lastMovementDate:
          StockModel._dateTimeFromJsonNullable(json['lastMovementDate']),
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'minQuantity': instance.minQuantity,
      'maxQuantity': instance.maxQuantity,
      'status': instance.status,
      'lastRestockDate': StockModel._dateTimeToJson(instance.lastRestockDate),
      'lastMovementDate': StockModel._dateTimeToJson(instance.lastMovementDate),
    };

NutritionalInfoModel _$NutritionalInfoModelFromJson(
        Map<String, dynamic> json) =>
    NutritionalInfoModel(
      calories: (json['calories'] as num?)?.toDouble(),
      proteins: (json['proteins'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      sugars: (json['sugars'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      saturatedFat: (json['saturatedFat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      salt: (json['salt'] as num?)?.toDouble(),
      vitamins: (json['vitamins'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$NutritionalInfoModelToJson(
        NutritionalInfoModel instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'proteins': instance.proteins,
      'carbohydrates': instance.carbohydrates,
      'sugars': instance.sugars,
      'fat': instance.fat,
      'saturatedFat': instance.saturatedFat,
      'fiber': instance.fiber,
      'salt': instance.salt,
      'vitamins': instance.vitamins,
    };
