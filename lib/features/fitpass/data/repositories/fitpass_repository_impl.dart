import '../../domain/entities/fitpass_entities.dart';
import '../../domain/repositories/fitpass_repository.dart';
import '../datasources/fitpass_remote_datasource.dart';

class FitPassRepositoryImpl implements FitPassRepository {
  final FitPassRemoteDataSource remoteDataSource;

  FitPassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FitPassPlan>> getPlans() async {
    return await remoteDataSource.getPlans();
  }

  @override
  Future<List<FitPassPartner>> getPartners({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    return await remoteDataSource.getPartners(latitude, longitude, radiusKm);
  }
}
