import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// The authenticated user in the Sportify system.
@freezed
abstract class User with _$User {
  const factory User({
    /// Unique user ID.
    required String id,

    /// User's email address.
    required String email,

    /// The user's role in the platform.
    required UserRole role,

    /// First name.
    required String firstName,

    /// Last name.
    required String lastName,

    /// Optional avatar URL.
    String? avatarUrl,

    /// JWT Access Token (if retrieved upon login).
    String? accessToken,
  }) = _User;

  const User._();

  /// Json deserialization for the User entity.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
