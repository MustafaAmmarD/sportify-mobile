import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportify/features/auth/presentation/pages/login_page.dart';
import 'package:sportify/features/auth/presentation/pages/register_page.dart';
import 'package:sportify/features/auth/presentation/pages/splash_page.dart';
import 'package:sportify/features/home/presentation/pages/home_page.dart';

/// Route paths.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
}

/// Re-evaluates router redirects whenever the auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _sub;

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }
}

/// App-wide router with auth guards:
/// - signed-out users can't open protected pages
/// - signed-in users skip login/register
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: _AuthRefresh(sl<AuthRepository>().authStateChanges),
  redirect: (context, state) {
    final signedIn = sl<AuthRepository>().currentUser != null;
    final path = state.matchedLocation;
    final isAuthPage = path == AppRoutes.login || path == AppRoutes.register;

    if (path == AppRoutes.splash) return null;
    if (signedIn && isAuthPage) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
  ],
);
