// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sale {

 String get id; String get merchantId; String get customerId; String get customerName; List<SaleItem> get items; double get totalAmount; double get discountAmount; double get finalAmount; DateTime get createdAt; DateTime? get collectedAt; SaleStatus get status; String get paymentMethod; String? get paymentTransactionId; bool get secureQrEnabled; String? get totpSecretId; String? get notes; Map<String, dynamic>? get metadata;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.finalAmount, finalAmount) || other.finalAmount == finalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.collectedAt, collectedAt) || other.collectedAt == collectedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.secureQrEnabled, secureQrEnabled) || other.secureQrEnabled == secureQrEnabled)&&(identical(other.totpSecretId, totpSecretId) || other.totpSecretId == totpSecretId)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerId,customerName,const DeepCollectionEquality().hash(items),totalAmount,discountAmount,finalAmount,createdAt,collectedAt,status,paymentMethod,paymentTransactionId,secureQrEnabled,totpSecretId,notes,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'Sale(id: $id, merchantId: $merchantId, customerId: $customerId, customerName: $customerName, items: $items, totalAmount: $totalAmount, discountAmount: $discountAmount, finalAmount: $finalAmount, createdAt: $createdAt, collectedAt: $collectedAt, status: $status, paymentMethod: $paymentMethod, paymentTransactionId: $paymentTransactionId, secureQrEnabled: $secureQrEnabled, totpSecretId: $totpSecretId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String customerId, String customerName, List<SaleItem> items, double totalAmount, double discountAmount, double finalAmount, DateTime createdAt, DateTime? collectedAt, SaleStatus status, String paymentMethod, String? paymentTransactionId, bool secureQrEnabled, String? totpSecretId, String? notes, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? customerId = null,Object? customerName = null,Object? items = null,Object? totalAmount = null,Object? discountAmount = null,Object? finalAmount = null,Object? createdAt = null,Object? collectedAt = freezed,Object? status = null,Object? paymentMethod = null,Object? paymentTransactionId = freezed,Object? secureQrEnabled = null,Object? totpSecretId = freezed,Object? notes = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,finalAmount: null == finalAmount ? _self.finalAmount : finalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,collectedAt: freezed == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SaleStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,secureQrEnabled: null == secureQrEnabled ? _self.secureQrEnabled : secureQrEnabled // ignore: cast_nullable_to_non_nullable
as bool,totpSecretId: freezed == totpSecretId ? _self.totpSecretId : totpSecretId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerId,  String customerName,  List<SaleItem> items,  double totalAmount,  double discountAmount,  double finalAmount,  DateTime createdAt,  DateTime? collectedAt,  SaleStatus status,  String paymentMethod,  String? paymentTransactionId,  bool secureQrEnabled,  String? totpSecretId,  String? notes,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerId,_that.customerName,_that.items,_that.totalAmount,_that.discountAmount,_that.finalAmount,_that.createdAt,_that.collectedAt,_that.status,_that.paymentMethod,_that.paymentTransactionId,_that.secureQrEnabled,_that.totpSecretId,_that.notes,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerId,  String customerName,  List<SaleItem> items,  double totalAmount,  double discountAmount,  double finalAmount,  DateTime createdAt,  DateTime? collectedAt,  SaleStatus status,  String paymentMethod,  String? paymentTransactionId,  bool secureQrEnabled,  String? totpSecretId,  String? notes,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.id,_that.merchantId,_that.customerId,_that.customerName,_that.items,_that.totalAmount,_that.discountAmount,_that.finalAmount,_that.createdAt,_that.collectedAt,_that.status,_that.paymentMethod,_that.paymentTransactionId,_that.secureQrEnabled,_that.totpSecretId,_that.notes,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String customerId,  String customerName,  List<SaleItem> items,  double totalAmount,  double discountAmount,  double finalAmount,  DateTime createdAt,  DateTime? collectedAt,  SaleStatus status,  String paymentMethod,  String? paymentTransactionId,  bool secureQrEnabled,  String? totpSecretId,  String? notes,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerId,_that.customerName,_that.items,_that.totalAmount,_that.discountAmount,_that.finalAmount,_that.createdAt,_that.collectedAt,_that.status,_that.paymentMethod,_that.paymentTransactionId,_that.secureQrEnabled,_that.totpSecretId,_that.notes,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sale implements Sale {
  const _Sale({required this.id, required this.merchantId, required this.customerId, required this.customerName, required final  List<SaleItem> items, required this.totalAmount, required this.discountAmount, required this.finalAmount, required this.createdAt, required this.collectedAt, required this.status, required this.paymentMethod, this.paymentTransactionId, this.secureQrEnabled = false, this.totpSecretId, this.notes, final  Map<String, dynamic>? metadata}): _items = items,_metadata = metadata;
  factory _Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String customerId;
@override final  String customerName;
 final  List<SaleItem> _items;
@override List<SaleItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalAmount;
@override final  double discountAmount;
@override final  double finalAmount;
@override final  DateTime createdAt;
@override final  DateTime? collectedAt;
@override final  SaleStatus status;
@override final  String paymentMethod;
@override final  String? paymentTransactionId;
@override@JsonKey() final  bool secureQrEnabled;
@override final  String? totpSecretId;
@override final  String? notes;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.finalAmount, finalAmount) || other.finalAmount == finalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.collectedAt, collectedAt) || other.collectedAt == collectedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.secureQrEnabled, secureQrEnabled) || other.secureQrEnabled == secureQrEnabled)&&(identical(other.totpSecretId, totpSecretId) || other.totpSecretId == totpSecretId)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerId,customerName,const DeepCollectionEquality().hash(_items),totalAmount,discountAmount,finalAmount,createdAt,collectedAt,status,paymentMethod,paymentTransactionId,secureQrEnabled,totpSecretId,notes,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'Sale(id: $id, merchantId: $merchantId, customerId: $customerId, customerName: $customerName, items: $items, totalAmount: $totalAmount, discountAmount: $discountAmount, finalAmount: $finalAmount, createdAt: $createdAt, collectedAt: $collectedAt, status: $status, paymentMethod: $paymentMethod, paymentTransactionId: $paymentTransactionId, secureQrEnabled: $secureQrEnabled, totpSecretId: $totpSecretId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String customerId, String customerName, List<SaleItem> items, double totalAmount, double discountAmount, double finalAmount, DateTime createdAt, DateTime? collectedAt, SaleStatus status, String paymentMethod, String? paymentTransactionId, bool secureQrEnabled, String? totpSecretId, String? notes, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? customerId = null,Object? customerName = null,Object? items = null,Object? totalAmount = null,Object? discountAmount = null,Object? finalAmount = null,Object? createdAt = null,Object? collectedAt = freezed,Object? status = null,Object? paymentMethod = null,Object? paymentTransactionId = freezed,Object? secureQrEnabled = null,Object? totpSecretId = freezed,Object? notes = freezed,Object? metadata = freezed,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,finalAmount: null == finalAmount ? _self.finalAmount : finalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,collectedAt: freezed == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SaleStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,secureQrEnabled: null == secureQrEnabled ? _self.secureQrEnabled : secureQrEnabled // ignore: cast_nullable_to_non_nullable
as bool,totpSecretId: freezed == totpSecretId ? _self.totpSecretId : totpSecretId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$SaleItem {

 String get offerId; String get offerTitle; FoodCategory get category; int get quantity; double get unitPrice; double get totalPrice;
/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleItemCopyWith<SaleItem> get copyWith => _$SaleItemCopyWithImpl<SaleItem>(this as SaleItem, _$identity);

  /// Serializes this SaleItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleItem&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.offerTitle, offerTitle) || other.offerTitle == offerTitle)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offerId,offerTitle,category,quantity,unitPrice,totalPrice);

@override
String toString() {
  return 'SaleItem(offerId: $offerId, offerTitle: $offerTitle, category: $category, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class $SaleItemCopyWith<$Res>  {
  factory $SaleItemCopyWith(SaleItem value, $Res Function(SaleItem) _then) = _$SaleItemCopyWithImpl;
@useResult
$Res call({
 String offerId, String offerTitle, FoodCategory category, int quantity, double unitPrice, double totalPrice
});




}
/// @nodoc
class _$SaleItemCopyWithImpl<$Res>
    implements $SaleItemCopyWith<$Res> {
  _$SaleItemCopyWithImpl(this._self, this._then);

  final SaleItem _self;
  final $Res Function(SaleItem) _then;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offerId = null,Object? offerTitle = null,Object? category = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,}) {
  return _then(_self.copyWith(
offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,offerTitle: null == offerTitle ? _self.offerTitle : offerTitle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FoodCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleItem].
extension SaleItemPatterns on SaleItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleItem value)  $default,){
final _that = this;
switch (_that) {
case _SaleItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleItem value)?  $default,){
final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String offerId,  String offerTitle,  FoodCategory category,  int quantity,  double unitPrice,  double totalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that.offerId,_that.offerTitle,_that.category,_that.quantity,_that.unitPrice,_that.totalPrice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String offerId,  String offerTitle,  FoodCategory category,  int quantity,  double unitPrice,  double totalPrice)  $default,) {final _that = this;
switch (_that) {
case _SaleItem():
return $default(_that.offerId,_that.offerTitle,_that.category,_that.quantity,_that.unitPrice,_that.totalPrice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String offerId,  String offerTitle,  FoodCategory category,  int quantity,  double unitPrice,  double totalPrice)?  $default,) {final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that.offerId,_that.offerTitle,_that.category,_that.quantity,_that.unitPrice,_that.totalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleItem implements SaleItem {
  const _SaleItem({required this.offerId, required this.offerTitle, required this.category, required this.quantity, required this.unitPrice, required this.totalPrice});
  factory _SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);

@override final  String offerId;
@override final  String offerTitle;
@override final  FoodCategory category;
@override final  int quantity;
@override final  double unitPrice;
@override final  double totalPrice;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleItemCopyWith<_SaleItem> get copyWith => __$SaleItemCopyWithImpl<_SaleItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleItem&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.offerTitle, offerTitle) || other.offerTitle == offerTitle)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offerId,offerTitle,category,quantity,unitPrice,totalPrice);

@override
String toString() {
  return 'SaleItem(offerId: $offerId, offerTitle: $offerTitle, category: $category, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class _$SaleItemCopyWith<$Res> implements $SaleItemCopyWith<$Res> {
  factory _$SaleItemCopyWith(_SaleItem value, $Res Function(_SaleItem) _then) = __$SaleItemCopyWithImpl;
@override @useResult
$Res call({
 String offerId, String offerTitle, FoodCategory category, int quantity, double unitPrice, double totalPrice
});




}
/// @nodoc
class __$SaleItemCopyWithImpl<$Res>
    implements _$SaleItemCopyWith<$Res> {
  __$SaleItemCopyWithImpl(this._self, this._then);

  final _SaleItem _self;
  final $Res Function(_SaleItem) _then;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offerId = null,Object? offerTitle = null,Object? category = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,}) {
  return _then(_SaleItem(
offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,offerTitle: null == offerTitle ? _self.offerTitle : offerTitle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FoodCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
