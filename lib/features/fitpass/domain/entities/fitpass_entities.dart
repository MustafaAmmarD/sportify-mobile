import 'package:equatable/equatable.dart';

class FitPassPlan extends Equatable {
  final String id;
  final String name; // e.g., 'Bronze', 'Silver', 'Gold', 'Club+', 'Digital'
  final double price;
  final String currency;
  final List<String> features;
  final bool isPopular;

  const FitPassPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.features,
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [id, name, price, currency, features, isPopular];
}

class FitPassPartner extends Equatable {
  final String id;
  final String name;
  final String type; // e.g., 'Gym', 'Pool', 'Yoga Studio'
  final String address;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String? imageUrl;
  final double rating;

  const FitPassPartner({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    this.imageUrl,
    this.rating = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        address,
        latitude,
        longitude,
        distanceKm,
        imageUrl,
        rating,
      ];
}
