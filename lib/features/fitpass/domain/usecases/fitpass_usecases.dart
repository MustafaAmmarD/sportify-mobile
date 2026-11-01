import '../entities/fitpass_entities.dart';
import '../repositories/fitpass_repository.dart';

class GetFitPassPlans {
  final FitPassRepository repository;

  GetFitPassPlans(this.repository);

  Future<List<FitPassPlan>> call() async {
    return await repository.getPlans();
  }
}

class GetFitPassPartners {
  final FitPassRepository repository;

  GetFitPassPartners(this.repository);

  Future<List<FitPassPartner>> call({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    return await repository.getPartners(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }
}
