import 'package:equatable/equatable.dart';

abstract class FitPassEvent extends Equatable {
  const FitPassEvent();

  @override
  List<Object> get props => [];
}

class FetchFitPassData extends FitPassEvent {
  final double latitude;
  final double longitude;

  const FetchFitPassData({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}
