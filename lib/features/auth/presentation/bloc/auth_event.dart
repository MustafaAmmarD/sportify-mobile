part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app start to restore a stored session.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  const AuthRegisterSubmitted({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.gdprConsent = true,
  });

  final String email;
  final String password;
  final UserRole role;
  final String firstName;
  final String lastName;
  final bool gdprConsent;

  @override
  List<Object?> get props =>
      [email, password, role, firstName, lastName, gdprConsent];
}

class AuthSocialLoginRequested extends AuthEvent {
  const AuthSocialLoginRequested(this.provider);

  final SocialProvider provider;

  @override
  List<Object?> get props => [provider];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Clears an error state, e.g. when the user starts editing again.
class AuthErrorDismissed extends AuthEvent {
  const AuthErrorDismissed();
}
