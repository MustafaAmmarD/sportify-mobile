import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';

/// Supported social login providers per roadmap.
enum SocialProvider { google, apple, facebook, tiktok }

/// Repository interface for authentication.
///
/// Implementations will handle API calls and local token storage.
abstract interface class AuthRepository {
  /// Stream of the currently authenticated user.
  /// Emits null when logged out.
  Stream<User?> get authStateChanges;

  /// Gets the currently cached user synchronously.
  User? get currentUser;

  /// Restores a previously stored session on app start.
  /// Returns `Right(null)` when nobody is signed in.
  Future<Either<Failure, User?>> restoreSession();

  /// Log in with email and password.
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Register a new account.
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required UserRole role,
    required String firstName,
    required String lastName,
    bool gdprConsent = true,
  });

  /// Log in using a social provider (Google, Apple, etc).
  Future<Either<Failure, User>> loginWithSocial(SocialProvider provider);

  /// Log out the current user.
  Future<Either<Failure, void>> logout();
}
