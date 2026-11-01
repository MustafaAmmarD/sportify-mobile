import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

/// Returns `true` if a user is signed in; otherwise shows a Guest Sign-In
/// bottom sheet and returns `false`.
bool ensureAuthenticatedOrPrompt(
  BuildContext context, {
  required String actionLabel,
}) {
  final user = sl<AuthRepository>().currentUser;
  if (user != null) return true;
  showGuestAuthPrompt(context, actionLabel: actionLabel);
  return false;
}

/// Shows a mobile-first prompt inviting guest users to log in or register.
void showGuestAuthPrompt(
  BuildContext context, {
  required String actionLabel,
}) {
  const card = Color(0xFF0E1822);
  const surface = Color(0xFF13202E);
  const border = Color(0xFF1B2A38);
  const green = AppColors.green2;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetCtx) => Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(color: green.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.lock_open_rounded, color: green, size: 26),
          ),
          const SizedBox(height: 16),
          Text(
            'Sign in to $actionLabel',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are currently browsing Sportify in Guest Mode. Create a free account or log in to connect with players, scouts, and clubs.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(sheetCtx).pop();
                context.go(AppRoutes.register);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: const Color(0xFF050A12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join Sportify Free',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(sheetCtx).pop();
                context.go(AppRoutes.login);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: surface,
                foregroundColor: Colors.white,
                side: const BorderSide(color: border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log In to Existing Account',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

