import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/presentation/widgets/player_ai_analysis_tab.dart';
import 'package:sportify/features/feed/presentation/widgets/player_career_tab.dart';
import 'package:sportify/features/feed/presentation/widgets/player_gallery_tab.dart';
import 'package:sportify/features/feed/presentation/widgets/player_highlights_tab.dart';
import 'package:sportify/features/feed/presentation/widgets/player_market_tab.dart';
import 'package:sportify/features/feed/presentation/widgets/player_overview_sections.dart';
import 'package:sportify/features/feed/presentation/widgets/player_profile_header.dart';
import 'package:sportify/features/feed/presentation/widgets/player_radar_card.dart';
import 'package:sportify/features/feed/presentation/widgets/player_statistics_tab.dart';

/// Mobile-first Player Scouting Profile screen.
///
/// Opens when tapping "View Profile →" on any [FeedHighlightCard].
class PlayerProfilePage extends StatefulWidget {
  const PlayerProfilePage({super.key, required this.post});

  final FeedPost post;

  @override
  State<PlayerProfilePage> createState() => _PlayerProfilePageState();
}

class _PlayerProfilePageState extends State<PlayerProfilePage> {
  static const List<String> _tabs = [
    'Overview',
    'Statistics',
    'Highlights',
    'Gallery',
    'Career',
    'Market',
    'AI Analysis',
  ];

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── 1. Hero Header (Backdrop, Portrait, Badges, Stats Strip) ──
            SliverToBoxAdapter(
              child: PlayerProfileHeader(post: widget.post),
            ),

            // ── 2. Scrollable Section Tab Strip ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 16),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final isSelected = i == _selectedTabIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? green : card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? green : border,
                            ),
                          ),
                          child: Text(
                            _tabs[i],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white70,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── 3. Active Tab Content ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverToBoxAdapter(
                child: switch (_selectedTabIndex) {
                  0 => _OverviewTabContent(post: widget.post),
                  1 => PlayerStatisticsTab(post: widget.post),
                  2 => PlayerHighlightsTab(post: widget.post),
                  3 => PlayerGalleryTab(post: widget.post),
                  4 => PlayerCareerTab(post: widget.post),
                  5 => PlayerMarketTab(post: widget.post),
                  _ => PlayerAiAnalysisTab(post: widget.post),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTabContent extends StatelessWidget {
  const _OverviewTabContent({required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlayerRadarCard(post: post),
        const SizedBox(height: 16),
        PlayerOverviewSections(post: post),
      ],
    );
  }
}

