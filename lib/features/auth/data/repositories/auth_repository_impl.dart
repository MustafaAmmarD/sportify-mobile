import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/exceptions.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:sportify/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  final _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? get currentUser => _currentUser;

  void _updateUser(User? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  /// Persists the session and publishes the new user.
  Future<User> _startSession(User user) async {
    final token = user.accessToken;
    if (token != null) await localDataSource.cacheToken(token);
    await localDataSource.cacheUser(user);
    _updateUser(user);
    return user;
  }

  /// Runs [action] and converts exceptions into [Failure]s.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ValidationException catch (e) {
      return Left(
        ValidationFailure(message: e.message, fieldErrors: e.errors),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on SportifyException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> restoreSession() async {
    try {
      final token = await localDataSource.getToken();
      final user = await localDataSource.getUser();
      if (token == null || user == null) {
        await localDataSource.clear();
        return const Right(null);
      }
      _updateUser(user);
      return Right(user);
    } on Exception {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final user = await remoteDataSource.loginWithEmail(email, password);
      return _startSession(user);
    });
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required UserRole role,
    required String firstName,
    required String lastName,
    bool gdprConsent = true,
  }) {
    return _guard(() async {
      final user = await remoteDataSource.register(
        email,
        password,
        role,
        firstName,
        lastName,
        gdprConsent,
      );
      return _startSession(user);
    });
  }

  @override
  Future<Either<Failure, User>> loginWithSocial(SocialProvider provider) {
    return _guard(() async {
      final user = await remoteDataSource.loginWithSocial(provider);
      return _startSession(user);
    });
  }

  @override
  Future<Either<Failure, void>> logout() {
    return _guard(() async {
      await remoteDataSource.logout();
      await localDataSource.clear();
      _updateUser(null);
    });
  }
}
