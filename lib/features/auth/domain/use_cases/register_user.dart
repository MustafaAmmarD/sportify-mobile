import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterParams> {
  const RegisterUser(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      role: params.role,
      firstName: params.firstName,
      lastName: params.lastName,
      gdprConsent: params.gdprConsent,
    );
  }
}

class RegisterParams {
  const RegisterParams({
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
}
