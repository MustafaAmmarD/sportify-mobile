import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Global [BlocObserver] that logs all Bloc/Cubit state transitions.
///
/// This is one of the biggest advantages of choosing Bloc over Riverpod —
/// every single event and state change across the entire app is logged here.
///
/// Attached in [main.dart] via `Bloc.observer = AppBlocObserver()`.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log('🟢 Created: ${bloc.runtimeType}', name: 'BLOC');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('📩 Event: ${bloc.runtimeType} ← $event', name: 'BLOC');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(
      '🔄 Transition: ${bloc.runtimeType}\n'
      '   Current: ${transition.currentState.runtimeType}\n'
      '   Event:   ${transition.event.runtimeType}\n'
      '   Next:    ${transition.nextState.runtimeType}',
      name: 'BLOC',
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Only log for Cubits (Blocs already log via onTransition)
    if (bloc is! Bloc) {
      log(
        '🔄 Change: ${bloc.runtimeType}\n'
        '   Current: ${change.currentState.runtimeType}\n'
        '   Next:    ${change.nextState.runtimeType}',
        name: 'CUBIT',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log(
      '❌ Error: ${bloc.runtimeType} — $error',
      name: 'BLOC',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log('🔴 Closed: ${bloc.runtimeType}', name: 'BLOC');
  }
}
