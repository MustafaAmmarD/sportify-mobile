import '../entities/fitpass_entities.dart';

abstract class FitPassRepository {
  Future<List<FitPassPlan>> getPlans();
  Future<List<FitPassPartner>> getPartners({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });
}
