// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantProfileModel {

 String get id; String get name; String get categoryKey; String? get logoUrl; String? get description; MerchantAddressModel? get address; String? get phoneNumber; String? get email; Map<String, OpeningHoursModel> get openingHours; GeoCoordinatesModel? get coordinates; DateTime? get createdAt; DateTime? get updatedAt; bool get isVerified; double get rating; int get totalReviews;
/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantProfileModelCopyWith<MerchantProfileModel> get copyWith => _$MerchantProfileModelCopyWithImpl<MerchantProfileModel>(this as MerchantProfileModel, _$identity);

  /// Serializes this MerchantProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.openingHours, openingHours)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryKey,logoUrl,description,address,phoneNumber,email,const DeepCollectionEquality().hash(openingHours),coordinates,createdAt,updatedAt,isVerified,rating,totalReviews);

@override
String toString() {
  return 'MerchantProfileModel(id: $id, name: $name, categoryKey: $categoryKey, logoUrl: $logoUrl, description: $description, address: $address, phoneNumber: $phoneNumber, email: $email, openingHours: $openingHours, coordinates: $coordinates, createdAt: $createdAt, updatedAt: $updatedAt, isVerified: $isVerified, rating: $rating, totalReviews: $totalReviews)';
}


}

/// @nodoc
abstract mixin class $MerchantProfileModelCopyWith<$Res>  {
  factory $MerchantProfileModelCopyWith(MerchantProfileModel value, $Res Function(MerchantProfileModel) _then) = _$MerchantProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryKey, String? logoUrl, String? description, MerchantAddressModel? address, String? phoneNumber, String? email, Map<String, OpeningHoursModel> openingHours, GeoCoordinatesModel? coordinates, DateTime? createdAt, DateTime? updatedAt, bool isVerified, double rating, int totalReviews
});


$MerchantAddressModelCopyWith<$Res>? get address;$GeoCoordinatesModelCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$MerchantProfileModelCopyWithImpl<$Res>
    implements $MerchantProfileModelCopyWith<$Res> {
  _$MerchantProfileModelCopyWithImpl(this._self, this._then);

  final MerchantProfileModel _self;
  final $Res Function(MerchantProfileModel) _then;

/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryKey = null,Object? logoUrl = freezed,Object? description = freezed,Object? address = freezed,Object? phoneNumber = freezed,Object? email = freezed,Object? openingHours = null,Object? coordinates = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isVerified = null,Object? rating = null,Object? totalReviews = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MerchantAddressModel?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,openingHours: null == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as Map<String, OpeningHoursModel>,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as GeoCoordinatesModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MerchantAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinatesModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $GeoCoordinatesModelCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [MerchantProfileModel].
extension MerchantProfileModelPatterns on MerchantProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _MerchantProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryKey,  String? logoUrl,  String? description,  MerchantAddressModel? address,  String? phoneNumber,  String? email,  Map<String, OpeningHoursModel> openingHours,  GeoCoordinatesModel? coordinates,  DateTime? createdAt,  DateTime? updatedAt,  bool isVerified,  double rating,  int totalReviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.categoryKey,_that.logoUrl,_that.description,_that.address,_that.phoneNumber,_that.email,_that.openingHours,_that.coordinates,_that.createdAt,_that.updatedAt,_that.isVerified,_that.rating,_that.totalReviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryKey,  String? logoUrl,  String? description,  MerchantAddressModel? address,  String? phoneNumber,  String? email,  Map<String, OpeningHoursModel> openingHours,  GeoCoordinatesModel? coordinates,  DateTime? createdAt,  DateTime? updatedAt,  bool isVerified,  double rating,  int totalReviews)  $default,) {final _that = this;
switch (_that) {
case _MerchantProfileModel():
return $default(_that.id,_that.name,_that.categoryKey,_that.logoUrl,_that.description,_that.address,_that.phoneNumber,_that.email,_that.openingHours,_that.coordinates,_that.createdAt,_that.updatedAt,_that.isVerified,_that.rating,_that.totalReviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryKey,  String? logoUrl,  String? description,  MerchantAddressModel? address,  String? phoneNumber,  String? email,  Map<String, OpeningHoursModel> openingHours,  GeoCoordinatesModel? coordinates,  DateTime? createdAt,  DateTime? updatedAt,  bool isVerified,  double rating,  int totalReviews)?  $default,) {final _that = this;
switch (_that) {
case _MerchantProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.categoryKey,_that.logoUrl,_that.description,_that.address,_that.phoneNumber,_that.email,_that.openingHours,_that.coordinates,_that.createdAt,_that.updatedAt,_that.isVerified,_that.rating,_that.totalReviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantProfileModel extends MerchantProfileModel {
  const _MerchantProfileModel({required this.id, required this.name, required this.categoryKey, this.logoUrl, this.description, this.address, this.phoneNumber, this.email, final  Map<String, OpeningHoursModel> openingHours = const {}, this.coordinates, this.createdAt, this.updatedAt, this.isVerified = false, this.rating = 0.0, this.totalReviews = 0}): _openingHours = openingHours,super._();
  factory _MerchantProfileModel.fromJson(Map<String, dynamic> json) => _$MerchantProfileModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String categoryKey;
@override final  String? logoUrl;
@override final  String? description;
@override final  MerchantAddressModel? address;
@override final  String? phoneNumber;
@override final  String? email;
 final  Map<String, OpeningHoursModel> _openingHours;
@override@JsonKey() Map<String, OpeningHoursModel> get openingHours {
  if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_openingHours);
}

@override final  GeoCoordinatesModel? coordinates;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalReviews;

/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantProfileModelCopyWith<_MerchantProfileModel> get copyWith => __$MerchantProfileModelCopyWithImpl<_MerchantProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryKey,logoUrl,description,address,phoneNumber,email,const DeepCollectionEquality().hash(_openingHours),coordinates,createdAt,updatedAt,isVerified,rating,totalReviews);

@override
String toString() {
  return 'MerchantProfileModel(id: $id, name: $name, categoryKey: $categoryKey, logoUrl: $logoUrl, description: $description, address: $address, phoneNumber: $phoneNumber, email: $email, openingHours: $openingHours, coordinates: $coordinates, createdAt: $createdAt, updatedAt: $updatedAt, isVerified: $isVerified, rating: $rating, totalReviews: $totalReviews)';
}


}

/// @nodoc
abstract mixin class _$MerchantProfileModelCopyWith<$Res> implements $MerchantProfileModelCopyWith<$Res> {
  factory _$MerchantProfileModelCopyWith(_MerchantProfileModel value, $Res Function(_MerchantProfileModel) _then) = __$MerchantProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryKey, String? logoUrl, String? description, MerchantAddressModel? address, String? phoneNumber, String? email, Map<String, OpeningHoursModel> openingHours, GeoCoordinatesModel? coordinates, DateTime? createdAt, DateTime? updatedAt, bool isVerified, double rating, int totalReviews
});


@override $MerchantAddressModelCopyWith<$Res>? get address;@override $GeoCoordinatesModelCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$MerchantProfileModelCopyWithImpl<$Res>
    implements _$MerchantProfileModelCopyWith<$Res> {
  __$MerchantProfileModelCopyWithImpl(this._self, this._then);

  final _MerchantProfileModel _self;
  final $Res Function(_MerchantProfileModel) _then;

/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryKey = null,Object? logoUrl = freezed,Object? description = freezed,Object? address = freezed,Object? phoneNumber = freezed,Object? email = freezed,Object? openingHours = null,Object? coordinates = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isVerified = null,Object? rating = null,Object? totalReviews = null,}) {
  return _then(_MerchantProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MerchantAddressModel?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,openingHours: null == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as Map<String, OpeningHoursModel>,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as GeoCoordinatesModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MerchantAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of MerchantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinatesModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $GeoCoordinatesModelCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// @nodoc
mixin _$MerchantAddressModel {

 String get street; String get postalCode; String get city; String? get complement; String get country;
/// Create a copy of MerchantAddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantAddressModelCopyWith<MerchantAddressModel> get copyWith => _$MerchantAddressModelCopyWithImpl<MerchantAddressModel>(this as MerchantAddressModel, _$identity);

  /// Serializes this MerchantAddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantAddressModel&&(identical(other.street, street) || other.street == street)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.complement, complement) || other.complement == complement)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,street,postalCode,city,complement,country);

@override
String toString() {
  return 'MerchantAddressModel(street: $street, postalCode: $postalCode, city: $city, complement: $complement, country: $country)';
}


}

/// @nodoc
abstract mixin class $MerchantAddressModelCopyWith<$Res>  {
  factory $MerchantAddressModelCopyWith(MerchantAddressModel value, $Res Function(MerchantAddressModel) _then) = _$MerchantAddressModelCopyWithImpl;
@useResult
$Res call({
 String street, String postalCode, String city, String? complement, String country
});




}
/// @nodoc
class _$MerchantAddressModelCopyWithImpl<$Res>
    implements $MerchantAddressModelCopyWith<$Res> {
  _$MerchantAddressModelCopyWithImpl(this._self, this._then);

  final MerchantAddressModel _self;
  final $Res Function(MerchantAddressModel) _then;

/// Create a copy of MerchantAddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? street = null,Object? postalCode = null,Object? city = null,Object? complement = freezed,Object? country = null,}) {
  return _then(_self.copyWith(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,complement: freezed == complement ? _self.complement : complement // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantAddressModel].
extension MerchantAddressModelPatterns on MerchantAddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantAddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantAddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantAddressModel value)  $default,){
final _that = this;
switch (_that) {
case _MerchantAddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantAddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantAddressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String street,  String postalCode,  String city,  String? complement,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantAddressModel() when $default != null:
return $default(_that.street,_that.postalCode,_that.city,_that.complement,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String street,  String postalCode,  String city,  String? complement,  String country)  $default,) {final _that = this;
switch (_that) {
case _MerchantAddressModel():
return $default(_that.street,_that.postalCode,_that.city,_that.complement,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String street,  String postalCode,  String city,  String? complement,  String country)?  $default,) {final _that = this;
switch (_that) {
case _MerchantAddressModel() when $default != null:
return $default(_that.street,_that.postalCode,_that.city,_that.complement,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantAddressModel extends MerchantAddressModel {
  const _MerchantAddressModel({required this.street, required this.postalCode, required this.city, this.complement, this.country = 'France'}): super._();
  factory _MerchantAddressModel.fromJson(Map<String, dynamic> json) => _$MerchantAddressModelFromJson(json);

@override final  String street;
@override final  String postalCode;
@override final  String city;
@override final  String? complement;
@override@JsonKey() final  String country;

/// Create a copy of MerchantAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantAddressModelCopyWith<_MerchantAddressModel> get copyWith => __$MerchantAddressModelCopyWithImpl<_MerchantAddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantAddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantAddressModel&&(identical(other.street, street) || other.street == street)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.complement, complement) || other.complement == complement)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,street,postalCode,city,complement,country);

@override
String toString() {
  return 'MerchantAddressModel(street: $street, postalCode: $postalCode, city: $city, complement: $complement, country: $country)';
}


}

/// @nodoc
abstract mixin class _$MerchantAddressModelCopyWith<$Res> implements $MerchantAddressModelCopyWith<$Res> {
  factory _$MerchantAddressModelCopyWith(_MerchantAddressModel value, $Res Function(_MerchantAddressModel) _then) = __$MerchantAddressModelCopyWithImpl;
@override @useResult
$Res call({
 String street, String postalCode, String city, String? complement, String country
});




}
/// @nodoc
class __$MerchantAddressModelCopyWithImpl<$Res>
    implements _$MerchantAddressModelCopyWith<$Res> {
  __$MerchantAddressModelCopyWithImpl(this._self, this._then);

  final _MerchantAddressModel _self;
  final $Res Function(_MerchantAddressModel) _then;

/// Create a copy of MerchantAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? street = null,Object? postalCode = null,Object? city = null,Object? complement = freezed,Object? country = null,}) {
  return _then(_MerchantAddressModel(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,complement: freezed == complement ? _self.complement : complement // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GeoCoordinatesModel {

 double get latitude; double get longitude;
/// Create a copy of GeoCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoCoordinatesModelCopyWith<GeoCoordinatesModel> get copyWith => _$GeoCoordinatesModelCopyWithImpl<GeoCoordinatesModel>(this as GeoCoordinatesModel, _$identity);

  /// Serializes this GeoCoordinatesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoCoordinatesModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinatesModel(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $GeoCoordinatesModelCopyWith<$Res>  {
  factory $GeoCoordinatesModelCopyWith(GeoCoordinatesModel value, $Res Function(GeoCoordinatesModel) _then) = _$GeoCoordinatesModelCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoCoordinatesModelCopyWithImpl<$Res>
    implements $GeoCoordinatesModelCopyWith<$Res> {
  _$GeoCoordinatesModelCopyWithImpl(this._self, this._then);

  final GeoCoordinatesModel _self;
  final $Res Function(GeoCoordinatesModel) _then;

/// Create a copy of GeoCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoCoordinatesModel].
extension GeoCoordinatesModelPatterns on GeoCoordinatesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoCoordinatesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoCoordinatesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoCoordinatesModel value)  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinatesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoCoordinatesModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinatesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoCoordinatesModel() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinatesModel():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinatesModel() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoCoordinatesModel extends GeoCoordinatesModel {
  const _GeoCoordinatesModel({required this.latitude, required this.longitude}): super._();
  factory _GeoCoordinatesModel.fromJson(Map<String, dynamic> json) => _$GeoCoordinatesModelFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoCoordinatesModelCopyWith<_GeoCoordinatesModel> get copyWith => __$GeoCoordinatesModelCopyWithImpl<_GeoCoordinatesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoCoordinatesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoCoordinatesModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinatesModel(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoCoordinatesModelCopyWith<$Res> implements $GeoCoordinatesModelCopyWith<$Res> {
  factory _$GeoCoordinatesModelCopyWith(_GeoCoordinatesModel value, $Res Function(_GeoCoordinatesModel) _then) = __$GeoCoordinatesModelCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoCoordinatesModelCopyWithImpl<$Res>
    implements _$GeoCoordinatesModelCopyWith<$Res> {
  __$GeoCoordinatesModelCopyWithImpl(this._self, this._then);

  final _GeoCoordinatesModel _self;
  final $Res Function(_GeoCoordinatesModel) _then;

/// Create a copy of GeoCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoCoordinatesModel(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OpeningHoursModel {

 String get openTime; String get closeTime; String? get breakStart; String? get breakEnd; bool get isClosed;
/// Create a copy of OpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpeningHoursModelCopyWith<OpeningHoursModel> get copyWith => _$OpeningHoursModelCopyWithImpl<OpeningHoursModel>(this as OpeningHoursModel, _$identity);

  /// Serializes this OpeningHoursModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpeningHoursModel&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openTime,closeTime,breakStart,breakEnd,isClosed);

@override
String toString() {
  return 'OpeningHoursModel(openTime: $openTime, closeTime: $closeTime, breakStart: $breakStart, breakEnd: $breakEnd, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class $OpeningHoursModelCopyWith<$Res>  {
  factory $OpeningHoursModelCopyWith(OpeningHoursModel value, $Res Function(OpeningHoursModel) _then) = _$OpeningHoursModelCopyWithImpl;
@useResult
$Res call({
 String openTime, String closeTime, String? breakStart, String? breakEnd, bool isClosed
});




}
/// @nodoc
class _$OpeningHoursModelCopyWithImpl<$Res>
    implements $OpeningHoursModelCopyWith<$Res> {
  _$OpeningHoursModelCopyWithImpl(this._self, this._then);

  final OpeningHoursModel _self;
  final $Res Function(OpeningHoursModel) _then;

/// Create a copy of OpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openTime = null,Object? closeTime = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? isClosed = null,}) {
  return _then(_self.copyWith(
openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OpeningHoursModel].
extension OpeningHoursModelPatterns on OpeningHoursModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpeningHoursModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpeningHoursModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpeningHoursModel value)  $default,){
final _that = this;
switch (_that) {
case _OpeningHoursModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpeningHoursModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpeningHoursModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String openTime,  String closeTime,  String? breakStart,  String? breakEnd,  bool isClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpeningHoursModel() when $default != null:
return $default(_that.openTime,_that.closeTime,_that.breakStart,_that.breakEnd,_that.isClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String openTime,  String closeTime,  String? breakStart,  String? breakEnd,  bool isClosed)  $default,) {final _that = this;
switch (_that) {
case _OpeningHoursModel():
return $default(_that.openTime,_that.closeTime,_that.breakStart,_that.breakEnd,_that.isClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String openTime,  String closeTime,  String? breakStart,  String? breakEnd,  bool isClosed)?  $default,) {final _that = this;
switch (_that) {
case _OpeningHoursModel() when $default != null:
return $default(_that.openTime,_that.closeTime,_that.breakStart,_that.breakEnd,_that.isClosed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpeningHoursModel extends OpeningHoursModel {
  const _OpeningHoursModel({required this.openTime, required this.closeTime, this.breakStart, this.breakEnd, this.isClosed = false}): super._();
  factory _OpeningHoursModel.fromJson(Map<String, dynamic> json) => _$OpeningHoursModelFromJson(json);

@override final  String openTime;
@override final  String closeTime;
@override final  String? breakStart;
@override final  String? breakEnd;
@override@JsonKey() final  bool isClosed;

/// Create a copy of OpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpeningHoursModelCopyWith<_OpeningHoursModel> get copyWith => __$OpeningHoursModelCopyWithImpl<_OpeningHoursModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpeningHoursModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpeningHoursModel&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openTime,closeTime,breakStart,breakEnd,isClosed);

@override
String toString() {
  return 'OpeningHoursModel(openTime: $openTime, closeTime: $closeTime, breakStart: $breakStart, breakEnd: $breakEnd, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class _$OpeningHoursModelCopyWith<$Res> implements $OpeningHoursModelCopyWith<$Res> {
  factory _$OpeningHoursModelCopyWith(_OpeningHoursModel value, $Res Function(_OpeningHoursModel) _then) = __$OpeningHoursModelCopyWithImpl;
@override @useResult
$Res call({
 String openTime, String closeTime, String? breakStart, String? breakEnd, bool isClosed
});




}
/// @nodoc
class __$OpeningHoursModelCopyWithImpl<$Res>
    implements _$OpeningHoursModelCopyWith<$Res> {
  __$OpeningHoursModelCopyWithImpl(this._self, this._then);

  final _OpeningHoursModel _self;
  final $Res Function(_OpeningHoursModel) _then;

/// Create a copy of OpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openTime = null,Object? closeTime = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? isClosed = null,}) {
  return _then(_OpeningHoursModel(
openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
