import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/exceptions.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';
import 'package:sportify/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.remoteDataSource});

  final ProfileRemoteDataSource remoteDataSource;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on SportifyException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) {
    return _guard(() => remoteDataSource.getProfile(userId));
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) {
    return _guard(() => remoteDataSource.updateProfile(profile));
  }
}
