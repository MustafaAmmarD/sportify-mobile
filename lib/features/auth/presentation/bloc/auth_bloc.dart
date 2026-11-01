import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportify/features/auth/domain/use_cases/login_with_email.dart';
import 'package:sportify/features/auth/domain/use_cases/login_with_social.dart';
import 'package:sportify/features/auth/domain/use_cases/logout.dart';
import 'package:sportify/features/auth/domain/use_cases/register_user.dart';
import 'package:sportify/features/auth/domain/use_cases/restore_session.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Drives login, registration, social login and logout.
///
/// Talks only to use cases, so it works the same with the mock data source
/// and with the real API later.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginWithEmail loginWithEmail,
    required RegisterUser registerUser,
    required LoginWithSocial loginWithSocial,
    required Logout logout,
    required RestoreSession restoreSession,
  })  : _loginWithEmail = loginWithEmail,
        _registerUser = registerUser,
        _loginWithSocial = loginWithSocial,
        _logout = logout,
        _restoreSession = restoreSession,
        super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthSocialLoginRequested>(_onSocial);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthErrorDismissed>((_, emit) => emit(const AuthInitial()));
  }

  final LoginWithEmail _loginWithEmail;
  final RegisterUser _registerUser;
  final LoginWithSocial _loginWithSocial;
  final Logout _logout;
  final RestoreSession _restoreSession;

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _restoreSession(const NoParams());
    emit(
      result.fold(
        // A broken cache simply means "not signed in".
        (_) => const AuthUnauthenticated(),
        (user) =>
            user == null ? const AuthUnauthenticated() : AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginWithEmail(
      LoginParams(email: event.email, password: event.password),
    );
    emit(_mapUser(result));
  }

  Future<void> _onRegister(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUser(
      RegisterParams(
        email: event.email,
        password: event.password,
        role: event.role,
        firstName: event.firstName,
        lastName: event.lastName,
        gdprConsent: event.gdprConsent,
      ),
    );
    emit(_mapUser(result));
  }

  Future<void> _onSocial(
    AuthSocialLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    emit(_mapUser(await _loginWithSocial(event.provider)));
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logout(const NoParams());
    emit(
      result.fold(
        AuthFailureState.new,
        (_) => const AuthUnauthenticated(),
      ),
    );
  }

  AuthState _mapUser(Either<Failure, User> result) => result.fold(
        AuthFailureState.new,
        AuthAuthenticated.new,
      );
}
