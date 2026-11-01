// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get userId; String? get bio; String? get position; String? get nationality; String? get preferredFoot; int? get heightCm; int? get weightKg; List<String> get videoLinks; bool get isAvailableForTransfer;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.position, position) || other.position == position)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.preferredFoot, preferredFoot) || other.preferredFoot == preferredFoot)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&const DeepCollectionEquality().equals(other.videoLinks, videoLinks)&&(identical(other.isAvailableForTransfer, isAvailableForTransfer) || other.isAvailableForTransfer == isAvailableForTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,bio,position,nationality,preferredFoot,heightCm,weightKg,const DeepCollectionEquality().hash(videoLinks),isAvailableForTransfer);

@override
String toString() {
  return 'Profile(id: $id, userId: $userId, bio: $bio, position: $position, nationality: $nationality, preferredFoot: $preferredFoot, heightCm: $heightCm, weightKg: $weightKg, videoLinks: $videoLinks, isAvailableForTransfer: $isAvailableForTransfer)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? bio, String? position, String? nationality, String? preferredFoot, int? heightCm, int? weightKg, List<String> videoLinks, bool isAvailableForTransfer
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? bio = freezed,Object? position = freezed,Object? nationality = freezed,Object? preferredFoot = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? videoLinks = null,Object? isAvailableForTransfer = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,preferredFoot: freezed == preferredFoot ? _self.preferredFoot : preferredFoot // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as int?,videoLinks: null == videoLinks ? _self.videoLinks : videoLinks // ignore: cast_nullable_to_non_nullable
as List<String>,isAvailableForTransfer: null == isAvailableForTransfer ? _self.isAvailableForTransfer : isAvailableForTransfer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? bio,  String? position,  String? nationality,  String? preferredFoot,  int? heightCm,  int? weightKg,  List<String> videoLinks,  bool isAvailableForTransfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.userId,_that.bio,_that.position,_that.nationality,_that.preferredFoot,_that.heightCm,_that.weightKg,_that.videoLinks,_that.isAvailableForTransfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? bio,  String? position,  String? nationality,  String? preferredFoot,  int? heightCm,  int? weightKg,  List<String> videoLinks,  bool isAvailableForTransfer)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.userId,_that.bio,_that.position,_that.nationality,_that.preferredFoot,_that.heightCm,_that.weightKg,_that.videoLinks,_that.isAvailableForTransfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? bio,  String? position,  String? nationality,  String? preferredFoot,  int? heightCm,  int? weightKg,  List<String> videoLinks,  bool isAvailableForTransfer)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.userId,_that.bio,_that.position,_that.nationality,_that.preferredFoot,_that.heightCm,_that.weightKg,_that.videoLinks,_that.isAvailableForTransfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile extends Profile {
  const _Profile({required this.id, required this.userId, this.bio, this.position, this.nationality, this.preferredFoot, this.heightCm, this.weightKg, final  List<String> videoLinks = const [], this.isAvailableForTransfer = false}): _videoLinks = videoLinks,super._();
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? bio;
@override final  String? position;
@override final  String? nationality;
@override final  String? preferredFoot;
@override final  int? heightCm;
@override final  int? weightKg;
 final  List<String> _videoLinks;
@override@JsonKey() List<String> get videoLinks {
  if (_videoLinks is EqualUnmodifiableListView) return _videoLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoLinks);
}

@override@JsonKey() final  bool isAvailableForTransfer;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.position, position) || other.position == position)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.preferredFoot, preferredFoot) || other.preferredFoot == preferredFoot)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&const DeepCollectionEquality().equals(other._videoLinks, _videoLinks)&&(identical(other.isAvailableForTransfer, isAvailableForTransfer) || other.isAvailableForTransfer == isAvailableForTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,bio,position,nationality,preferredFoot,heightCm,weightKg,const DeepCollectionEquality().hash(_videoLinks),isAvailableForTransfer);

@override
String toString() {
  return 'Profile(id: $id, userId: $userId, bio: $bio, position: $position, nationality: $nationality, preferredFoot: $preferredFoot, heightCm: $heightCm, weightKg: $weightKg, videoLinks: $videoLinks, isAvailableForTransfer: $isAvailableForTransfer)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? bio, String? position, String? nationality, String? preferredFoot, int? heightCm, int? weightKg, List<String> videoLinks, bool isAvailableForTransfer
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? bio = freezed,Object? position = freezed,Object? nationality = freezed,Object? preferredFoot = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? videoLinks = null,Object? isAvailableForTransfer = null,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,preferredFoot: freezed == preferredFoot ? _self.preferredFoot : preferredFoot // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as int?,videoLinks: null == videoLinks ? _self._videoLinks : videoLinks // ignore: cast_nullable_to_non_nullable
as List<String>,isAvailableForTransfer: null == isAvailableForTransfer ? _self.isAvailableForTransfer : isAvailableForTransfer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
