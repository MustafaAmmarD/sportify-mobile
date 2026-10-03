import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportify/core/localization/cubit/locale_cubit.dart';
import 'package:sportify/core/network/api_client.dart';
import 'package:sportify/core/theme/cubit/theme_cubit.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies in the correct order.
///
/// Called once in `main.dart` before `runApp`.
///
/// Registration order:
/// 1. External / 3rd party
/// 2. Core services (networking, storage)
/// 3. Data sources
/// 4. Repositories
/// 5. Use cases
/// 6. Blocs (as Factory — new instance per screen)
Future<void> initDependencies() async {
  // ── 0. External ──
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    // ── 1. Core ──
    ..registerLazySingleton<ApiClient>(ApiClient.new)
    ..registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()))
    ..registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  // ── 2. Data Sources ──
  // Will be added when we build the Scouting data layer

  // ── 3. Repositories ──
  // Will be added when we build the Scouting domain layer

  // ── 4. Use Cases ──
  // Will be added when we build the Scouting use cases

  // ── 5. Blocs ──
  // Will be added when we build the Scouting presentation layer
}
