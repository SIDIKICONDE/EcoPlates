// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Sale _$SaleFromJson(Map<String, dynamic> json) {
  return _Sale.fromJson(json);
}

/// @nodoc
mixin _$Sale {
  String get id => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  List<SaleItem> get items => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get finalAmount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get collectedAt => throw _privateConstructorUsedError;
  SaleStatus get status => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentTransactionId => throw _privateConstructorUsedError;
  String? get qrCode => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleCopyWith<Sale> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleCopyWith<$Res> {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) then) =
      _$SaleCopyWithImpl<$Res, Sale>;
  @useResult
  $Res call({
    String id,
    String merchantId,
    String customerId,
    String customerName,
    List<SaleItem> items,
    double totalAmount,
    double discountAmount,
    double finalAmount,
    DateTime createdAt,
    DateTime? collectedAt,
    SaleStatus status,
    String paymentMethod,
    String? paymentTransactionId,
    String? qrCode,
    String? notes,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$SaleCopyWithImpl<$Res, $Val extends Sale>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? discountAmount = null,
    Object? finalAmount = null,
    Object? createdAt = null,
    Object? collectedAt = freezed,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentTransactionId = freezed,
    Object? qrCode = freezed,
    Object? notes = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            merchantId: null == merchantId
                ? _value.merchantId
                : merchantId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<SaleItem>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            finalAmount: null == finalAmount
                ? _value.finalAmount
                : finalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            collectedAt: freezed == collectedAt
                ? _value.collectedAt
                : collectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SaleStatus,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentTransactionId: freezed == paymentTransactionId
                ? _value.paymentTransactionId
                : paymentTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qrCode: freezed == qrCode
                ? _value.qrCode
                : qrCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleImplCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$$SaleImplCopyWith(
    _$SaleImpl value,
    $Res Function(_$SaleImpl) then,
  ) = __$$SaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String merchantId,
    String customerId,
    String customerName,
    List<SaleItem> items,
    double totalAmount,
    double discountAmount,
    double finalAmount,
    DateTime createdAt,
    DateTime? collectedAt,
    SaleStatus status,
    String paymentMethod,
    String? paymentTransactionId,
    String? qrCode,
    String? notes,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$SaleImplCopyWithImpl<$Res>
    extends _$SaleCopyWithImpl<$Res, _$SaleImpl>
    implements _$$SaleImplCopyWith<$Res> {
  __$$SaleImplCopyWithImpl(_$SaleImpl _value, $Res Function(_$SaleImpl) _then)
    : super(_value, _then);

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? discountAmount = null,
    Object? finalAmount = null,
    Object? createdAt = null,
    Object? collectedAt = freezed,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentTransactionId = freezed,
    Object? qrCode = freezed,
    Object? notes = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SaleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        merchantId: null == merchantId
            ? _value.merchantId
            : merchantId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<SaleItem>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        finalAmount: null == finalAmount
            ? _value.finalAmount
            : finalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        collectedAt: freezed == collectedAt
            ? _value.collectedAt
            : collectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SaleStatus,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentTransactionId: freezed == paymentTransactionId
            ? _value.paymentTransactionId
            : paymentTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qrCode: freezed == qrCode
            ? _value.qrCode
            : qrCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleImpl implements _Sale {
  const _$SaleImpl({
    required this.id,
    required this.merchantId,
    required this.customerId,
    required this.customerName,
    required final List<SaleItem> items,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.collectedAt,
    required this.status,
    required this.paymentMethod,
    this.paymentTransactionId,
    this.qrCode,
    this.notes,
    final Map<String, dynamic>? metadata,
  }) : _items = items,
       _metadata = metadata;

  factory _$SaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleImplFromJson(json);

  @override
  final String id;
  @override
  final String merchantId;
  @override
  final String customerId;
  @override
  final String customerName;
  final List<SaleItem> _items;
  @override
  List<SaleItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double totalAmount;
  @override
  final double discountAmount;
  @override
  final double finalAmount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? collectedAt;
  @override
  final SaleStatus status;
  @override
  final String paymentMethod;
  @override
  final String? paymentTransactionId;
  @override
  final String? qrCode;
  @override
  final String? notes;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Sale(id: $id, merchantId: $merchantId, customerId: $customerId, customerName: $customerName, items: $items, totalAmount: $totalAmount, discountAmount: $discountAmount, finalAmount: $finalAmount, createdAt: $createdAt, collectedAt: $collectedAt, status: $status, paymentMethod: $paymentMethod, paymentTransactionId: $paymentTransactionId, qrCode: $qrCode, notes: $notes, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.finalAmount, finalAmount) ||
                other.finalAmount == finalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    merchantId,
    customerId,
    customerName,
    const DeepCollectionEquality().hash(_items),
    totalAmount,
    discountAmount,
    finalAmount,
    createdAt,
    collectedAt,
    status,
    paymentMethod,
    paymentTransactionId,
    qrCode,
    notes,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleImplCopyWith<_$SaleImpl> get copyWith =>
      __$$SaleImplCopyWithImpl<_$SaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleImplToJson(this);
  }
}

abstract class _Sale implements Sale {
  const factory _Sale({
    required final String id,
    required final String merchantId,
    required final String customerId,
    required final String customerName,
    required final List<SaleItem> items,
    required final double totalAmount,
    required final double discountAmount,
    required final double finalAmount,
    required final DateTime createdAt,
    required final DateTime? collectedAt,
    required final SaleStatus status,
    required final String paymentMethod,
    final String? paymentTransactionId,
    final String? qrCode,
    final String? notes,
    final Map<String, dynamic>? metadata,
  }) = _$SaleImpl;

  factory _Sale.fromJson(Map<String, dynamic> json) = _$SaleImpl.fromJson;

  @override
  String get id;
  @override
  String get merchantId;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  List<SaleItem> get items;
  @override
  double get totalAmount;
  @override
  double get discountAmount;
  @override
  double get finalAmount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get collectedAt;
  @override
  SaleStatus get status;
  @override
  String get paymentMethod;
  @override
  String? get paymentTransactionId;
  @override
  String? get qrCode;
  @override
  String? get notes;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleImplCopyWith<_$SaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleItem _$SaleItemFromJson(Map<String, dynamic> json) {
  return _SaleItem.fromJson(json);
}

/// @nodoc
mixin _$SaleItem {
  String get offerId => throw _privateConstructorUsedError;
  String get offerTitle => throw _privateConstructorUsedError;
  FoodCategory get category => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  /// Serializes this SaleItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleItemCopyWith<SaleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemCopyWith<$Res> {
  factory $SaleItemCopyWith(SaleItem value, $Res Function(SaleItem) then) =
      _$SaleItemCopyWithImpl<$Res, SaleItem>;
  @useResult
  $Res call({
    String offerId,
    String offerTitle,
    FoodCategory category,
    int quantity,
    double unitPrice,
    double totalPrice,
  });
}

/// @nodoc
class _$SaleItemCopyWithImpl<$Res, $Val extends SaleItem>
    implements $SaleItemCopyWith<$Res> {
  _$SaleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offerId = null,
    Object? offerTitle = null,
    Object? category = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
  }) {
    return _then(
      _value.copyWith(
            offerId: null == offerId
                ? _value.offerId
                : offerId // ignore: cast_nullable_to_non_nullable
                      as String,
            offerTitle: null == offerTitle
                ? _value.offerTitle
                : offerTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as FoodCategory,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleItemImplCopyWith<$Res>
    implements $SaleItemCopyWith<$Res> {
  factory _$$SaleItemImplCopyWith(
    _$SaleItemImpl value,
    $Res Function(_$SaleItemImpl) then,
  ) = __$$SaleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String offerId,
    String offerTitle,
    FoodCategory category,
    int quantity,
    double unitPrice,
    double totalPrice,
  });
}

/// @nodoc
class __$$SaleItemImplCopyWithImpl<$Res>
    extends _$SaleItemCopyWithImpl<$Res, _$SaleItemImpl>
    implements _$$SaleItemImplCopyWith<$Res> {
  __$$SaleItemImplCopyWithImpl(
    _$SaleItemImpl _value,
    $Res Function(_$SaleItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offerId = null,
    Object? offerTitle = null,
    Object? category = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
  }) {
    return _then(
      _$SaleItemImpl(
        offerId: null == offerId
            ? _value.offerId
            : offerId // ignore: cast_nullable_to_non_nullable
                  as String,
        offerTitle: null == offerTitle
            ? _value.offerTitle
            : offerTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as FoodCategory,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleItemImpl implements _SaleItem {
  const _$SaleItemImpl({
    required this.offerId,
    required this.offerTitle,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory _$SaleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleItemImplFromJson(json);

  @override
  final String offerId;
  @override
  final String offerTitle;
  @override
  final FoodCategory category;
  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double totalPrice;

  @override
  String toString() {
    return 'SaleItem(offerId: $offerId, offerTitle: $offerTitle, category: $category, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemImpl &&
            (identical(other.offerId, offerId) || other.offerId == offerId) &&
            (identical(other.offerTitle, offerTitle) ||
                other.offerTitle == offerTitle) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    offerId,
    offerTitle,
    category,
    quantity,
    unitPrice,
    totalPrice,
  );

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemImplCopyWith<_$SaleItemImpl> get copyWith =>
      __$$SaleItemImplCopyWithImpl<_$SaleItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleItemImplToJson(this);
  }
}

abstract class _SaleItem implements SaleItem {
  const factory _SaleItem({
    required final String offerId,
    required final String offerTitle,
    required final FoodCategory category,
    required final int quantity,
    required final double unitPrice,
    required final double totalPrice,
  }) = _$SaleItemImpl;

  factory _SaleItem.fromJson(Map<String, dynamic> json) =
      _$SaleItemImpl.fromJson;

  @override
  String get offerId;
  @override
  String get offerTitle;
  @override
  FoodCategory get category;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleItemImplCopyWith<_$SaleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
