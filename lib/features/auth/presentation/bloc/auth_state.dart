part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthFailureState extends AuthState {
  const AuthFailureState(this.failure);

  final Failure failure;

  String get message => failure.message;

  /// Field-level errors when the failure is a [ValidationFailure].
  Map<String, List<String>> get fieldErrors => switch (failure) {
        ValidationFailure(:final fieldErrors) => fieldErrors,
        _ => const {},
      };

  @override
  List<Object?> get props => [failure];
}
