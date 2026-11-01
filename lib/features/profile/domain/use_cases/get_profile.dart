import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';
import 'package:sportify/features/profile/domain/repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile, String> {
  const GetProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, Profile>> call(String userId) {
    return repository.getProfile(userId);
  }
}
