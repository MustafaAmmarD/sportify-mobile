import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/utils/user_role_ui.dart';
import '../../domain/entities/profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_cv_card.dart';
import '../widgets/profile_fitpass_card.dart';
import '../widgets/profile_quick_actions_hub.dart';
import '../widgets/profile_stats_banner.dart';
import '../widgets/profile_video_card.dart';

Color _roleColor(String role) {
  switch (role.toLowerCase()) {
    case 'player':
      return AppColors.green2;
    case 'club':
      return const Color(0xFF38BDF8);
    case 'agent':
      return const Color(0xFFF59E0B);
    case 'scout':
      return const Color(0xFF818CF8);
    case 'coach':
      return const Color(0xFFF97316);
    case 'fan':
      return const Color(0xFFEC4899);
    default:
      return const Color(0xFF94A3B8);
  }
}

/// User profile page with personal info, Football CV, highlight reels, and FIT-Pass status.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<AuthRepository>().currentUser;
    if (user == null) {
      return const ColoredBox(
        color: Color(0xFF070D14),
        child: Center(
          child: Text(
            'Not signed in.',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..fetchProfile(user.id),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = sl<AuthRepository>().currentUser!;

    return ColoredBox(
      color: const Color(0xFF070D14),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.green2));
          }
          if (state is ProfileError) {
            return Center(
              child: Text(
                state.failure.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          if (state is ProfileLoaded) {
            return _ProfileContent(user: user, profile: state.profile, l10n: l10n);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
    required this.profile,
    required this.l10n,
  });

  final User user;
  final Profile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.role.label(l10n);
    final accent = _roleColor(user.role.name);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProfileCoverHeader(
          user: user,
          profile: profile,
          roleLabel: roleLabel,
          accent: accent,
          l10n: l10n,
          onSettingsTap: () => showProfileSettingsSheet(context),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ProfileQuickActionsHub(user: user),
              const SizedBox(height: 16),
              ProfileStatsBanner(profile: profile),
              const SizedBox(height: 16),
              ProfileCvCard(profile: profile, l10n: l10n),
              const SizedBox(height: 16),
              if (profile.videoLinks.isNotEmpty) ...[
                ProfileVideoCard(links: profile.videoLinks, l10n: l10n),
                const SizedBox(height: 16),
              ],
              const ProfileFitPassCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
