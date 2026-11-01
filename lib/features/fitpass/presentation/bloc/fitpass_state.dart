import 'package:equatable/equatable.dart';
import '../../domain/entities/fitpass_entities.dart';

abstract class FitPassState extends Equatable {
  const FitPassState();

  @override
  List<Object?> get props => [];
}

class FitPassInitial extends FitPassState {}

class FitPassLoading extends FitPassState {}

class FitPassLoaded extends FitPassState {
  final List<FitPassPlan> plans;
  final List<FitPassPartner> partners;

  const FitPassLoaded({
    required this.plans,
    required this.partners,
  });

  @override
  List<Object?> get props => [plans, partners];
}

class FitPassError extends FitPassState {
  final String message;

  const FitPassError(this.message);

  @override
  List<Object?> get props => [message];
}
