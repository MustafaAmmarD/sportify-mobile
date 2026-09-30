import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/app/app.dart';
import 'package:sportify/app/app_bloc_observer.dart';
import 'package:sportify/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initDependencies();

  // Set up global Bloc observer for debugging
  Bloc.observer = AppBlocObserver();

  runApp(const SportifyApp());
}
