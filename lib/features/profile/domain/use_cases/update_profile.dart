import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';
import 'package:sportify/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile implements UseCase<Profile, Profile> {
  const UpdateProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, Profile>> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}
