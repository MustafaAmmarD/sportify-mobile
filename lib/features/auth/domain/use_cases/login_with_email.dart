import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmail implements UseCase<User, LoginParams> {
  const LoginWithEmail(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}
