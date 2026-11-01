import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

class LoginWithSocial implements UseCase<User, SocialProvider> {
  const LoginWithSocial(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(SocialProvider provider) {
    return repository.loginWithSocial(provider);
  }
}
