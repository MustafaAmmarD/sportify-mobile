import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/localization/sportify_l10n.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/news/presentation/bloc/news_bloc.dart';
import 'package:sportify/features/news/presentation/bloc/news_event.dart';
import 'package:sportify/features/news/presentation/bloc/news_state.dart';
import 'package:sportify/features/news/presentation/widgets/news_matches_and_reader.dart';
import 'package:sportify/features/news/presentation/widgets/news_tab_view.dart';
import 'package:sportify/features/news/presentation/widgets/transfers_tab_view.dart';

/// Unified Football News + Transfers page with top segment toggle.
///
/// Replaces the separate NewsPage and TransfersPage — a single
/// [NewsBloc] feeds both segments to avoid duplicate network calls.
class NewsHubPage extends StatelessWidget {
  const NewsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>()..add(FetchNewsAndTransfers()),
      child: const _NewsHubView(),
    );
  }
}

class _NewsHubView extends StatefulWidget {
  const _NewsHubView();

  @override
  State<_NewsHubView> createState() => _NewsHubViewState();
}

class _NewsHubViewState extends State<_NewsHubView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    final tr = SportifyL10n.of(context);

    return ColoredBox(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Custom header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr.hubTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _HeaderActionButton(
                    icon: Icons.search_rounded,
                    onTap: () {
                      _tabController.animateTo(1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Use the Transfers search bar to find players & clubs.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _HeaderActionButton(
                    icon: Icons.notifications_active_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Breaking Goal & Transfer Alerts enabled 🔔'),
                          backgroundColor: AppColors.green2,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Segment toggle ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: green.withValues(alpha: 0.5)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: green,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  dividerHeight: 0,
                  splashBorderRadius: BorderRadius.circular(10),
                  tabs: [
                    Tab(text: tr.hubTabNews),
                    Tab(text: tr.hubTabTransfers),
                    Tab(text: tr.hubTabMatches),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Tab content ──
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsInitial || state is NewsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: green),
                    );
                  }
                  if (state is NewsError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }
                  if (state is! NewsLoaded) return const SizedBox.shrink();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      NewsTabView(state: state),
                      TransfersTabView(state: state),
                      const MatchesTabView(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small icon button for the custom page header.
class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0E1822),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1B2A38)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }
}
