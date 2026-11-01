import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String userId,
    String? bio,
    String? position,
    String? nationality,
    String? preferredFoot,
    int? heightCm,
    int? weightKg,
    @Default([]) List<String> videoLinks,
    @Default(false) bool isAvailableForTransfer,
  }) = _Profile;

  const Profile._();

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
