import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);
  
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
}
