import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fitpass_entities.dart';
import '../../domain/usecases/fitpass_usecases.dart';
import 'fitpass_event.dart';
import 'fitpass_state.dart';

class FitPassBloc extends Bloc<FitPassEvent, FitPassState> {
  final GetFitPassPlans getFitPassPlans;
  final GetFitPassPartners getFitPassPartners;

  FitPassBloc({
    required this.getFitPassPlans,
    required this.getFitPassPartners,
  }) : super(FitPassInitial()) {
    on<FetchFitPassData>(_onFetchFitPassData);
  }

  Future<void> _onFetchFitPassData(
    FetchFitPassData event,
    Emitter<FitPassState> emit,
  ) async {
    emit(FitPassLoading());
    try {
      final results = await Future.wait([
        getFitPassPlans(),
        getFitPassPartners(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      ]);

      final plansList = (results[0] as List).cast<FitPassPlan>().toList();
      final partnersList = (results[1] as List).cast<FitPassPartner>().toList();

      emit(FitPassLoaded(
        plans: plansList,
        partners: partnersList,
      ));
    } catch (e) {
      emit(FitPassError(e.toString()));
    }
  }
}
