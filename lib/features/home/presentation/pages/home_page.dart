import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sportify/features/feed/presentation/pages/feed_page.dart';
import 'package:sportify/features/feed/presentation/widgets/guest_auth_sheet.dart';
import 'package:sportify/features/fitpass/presentation/pages/fitpass_page.dart';
import 'package:sportify/features/news/presentation/pages/news_hub_page.dart';
import 'package:sportify/features/profile/presentation/pages/profile_page.dart';

/// The main shell of the app featuring a 4-tab bottom navigation.
///
/// Tabs: Home (Feed) · News · FIT-Pass · Profile
/// Chat and Company are accessed from Profile or contextual AppBar icons.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    FeedPage(),
    NewsHubPage(),
    FitPassPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          setState(() => _currentIndex = 0);
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF070D14),
        // No global AppBar — each page manages its own header.
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (idx) {
            if (idx == 3 && !ensureAuthenticatedOrPrompt(context, actionLabel: 'manage your Sportify profile')) {
              return;
            }
            setState(() => _currentIndex = idx);
          },
          l10n: l10n,
        ),
      ),
    );
  }
}

/// Custom bottom navigation bar styled for the Sportify dark theme.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.l10n,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    const inactiveColor = Color(0xFF5A6B7D);

    final items = <_NavItem>[
      _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: l10n.tabFeed),
      _NavItem(icon: Icons.article_outlined, activeIcon: Icons.article_rounded, label: l10n.tabNews),
      _NavItem(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: l10n.tabFitPass),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.tabProfile),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Active indicator dot
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: isActive ? 20 : 0,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isActive ? green : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive ? green : inactiveColor,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isActive ? green : inactiveColor,
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
