import '../../domain/entities/fitpass_entities.dart';

abstract class FitPassRemoteDataSource {
  Future<List<FitPassPlan>> getPlans();
  Future<List<FitPassPartner>> getPartners(
    double latitude,
    double longitude,
    double radiusKm,
  );
}

class FitPassRemoteDataSourceImpl implements FitPassRemoteDataSource {
  const FitPassRemoteDataSourceImpl();

  @override
  Future<List<FitPassPlan>> getPlans() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock data based on sportifyplus.de roadmap
    return [
      const FitPassPlan(
        id: 'plan-1',
        name: 'Bronze',
        price: 29.99,
        currency: 'EUR',
        features: ['Gym Access', 'Pool'],
      ),
      const FitPassPlan(
        id: 'plan-2',
        name: 'Silver',
        price: 49.99,
        currency: 'EUR',
        features: ['Gym Access', 'Pool', 'Group Classes'],
        isPopular: true,
      ),
      const FitPassPlan(
        id: 'plan-3',
        name: 'Gold',
        price: 79.99,
        currency: 'EUR',
        features: ['Gym Access', 'Pool', 'Group Classes', 'Personal Training', 'Sauna'],
      ),
      const FitPassPlan(
        id: 'plan-4',
        name: 'Club+',
        price: 99.99,
        currency: 'EUR',
        features: ['Everything in Gold', 'VIP Club Access', 'Nutrition Plan'],
      ),
      const FitPassPlan(
        id: 'plan-5',
        name: 'Digital',
        price: 9.99,
        currency: 'EUR',
        features: ['Online Workouts', 'Diet Tracking', 'Community Access'],
      ),
    ];
  }

  @override
  Future<List<FitPassPartner>> getPartners(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock data based on sportifyplus.de partners concept
    return [
      const FitPassPartner(
        id: 'partner-1',
        name: 'FitX Berlin',
        type: 'Gym',
        address: 'Alexanderplatz 1, Berlin',
        latitude: 52.5219,
        longitude: 13.4132,
        distanceKm: 1.2,
        imageUrl: null,
        rating: 4.8,
      ),
      const FitPassPartner(
        id: 'partner-2',
        name: 'McFIT Mitte',
        type: 'Gym',
        address: 'Heinrich-Heine-Str. 15, Berlin',
        latitude: 52.5098,
        longitude: 13.4150,
        distanceKm: 2.5,
        imageUrl: null,
        rating: 4.5,
      ),
      const FitPassPartner(
        id: 'partner-3',
        name: 'Yoga Elements',
        type: 'Yoga Studio',
        address: 'Rosenthaler Str. 40, Berlin',
        latitude: 52.5255,
        longitude: 13.4027,
        distanceKm: 1.8,
        imageUrl: null,
        rating: 4.9,
      ),
      const FitPassPartner(
        id: 'partner-4',
        name: 'Liquidrom Pool & Sauna',
        type: 'Pool',
        address: 'Möckernstr. 10, Berlin',
        latitude: 52.5015,
        longitude: 13.3811,
        distanceKm: 3.5,
        imageUrl: null,
        rating: 4.7,
      ),
    ];
  }
}
