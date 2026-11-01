import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

/// Restores the stored session (if any) when the app starts.
class RestoreSession implements UseCase<User?, NoParams> {
  const RestoreSession(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.restoreSession();
  }
}
