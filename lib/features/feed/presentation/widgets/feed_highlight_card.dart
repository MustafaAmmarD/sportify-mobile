import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/presentation/pages/player_profile_page.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_interaction_sheets.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_media_stage.dart';
import 'package:sportify/features/feed/presentation/widgets/video_launcher.dart';

/// Mobile-first player scouting & highlight card.
///
/// - Tapping the **video stage / center play button** opens the highlight video.
/// - Tapping **View Profile →** triggers [onViewProfile] or opens [PlayerProfilePage].
class FeedHighlightCard extends StatelessWidget {
  const FeedHighlightCard({
    super.key,
    required this.post,
    this.onViewProfile,
    this.onTagTap,
  });

  final FeedPost post;
  final ValueChanged<FeedPost>? onViewProfile;
  final ValueChanged<String>? onTagTap;

  void _openVideo(BuildContext context) => openVideoUrl(context, post.videoUrl);

  void _handleViewProfile(BuildContext context) {
    if (onViewProfile != null) return onViewProfile!(post);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PlayerProfilePage(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF0B141E);
    const surfaceBg = Color(0xFF111E2C);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Interactive Video Stage (Tap to Play Highlight) ──
          FeedMediaStage(
            post: post,
            onPlayTap: () => _openVideo(context),
          ),

          // ── 2. Mobile Scouting Details & View Profile Action ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Club info + Competition level pill
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: border),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: green,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.clubName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (post.clubCity.isNotEmpty ||
                              post.leagueName.isNotEmpty)
                            Text(
                              [
                                if (post.clubCity.isNotEmpty) post.clubCity,
                                if (post.leagueName.isNotEmpty) post.leagueName,
                              ].join(' · '),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: green.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        post.competitionLevel,
                        style: const TextStyle(
                          color: green,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Compact 3-column physical & club attributes bar + languages
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      _StatMetric(label: 'Foot', value: post.preferredFoot),
                      _VerticalDivider(),
                      _StatMetric(
                        label: 'Height',
                        value: '${post.heightCm}cm',
                      ),
                      _VerticalDivider(),
                      _StatMetric(label: 'Club', value: post.clubCountry),
                      _VerticalDivider(),
                      Expanded(
                        flex: 4,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.end,
                          children: post.languages
                              .take(2)
                              .map(
                                (lang) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: border),
                                  ),
                                  child: Text(
                                    lang,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Interactive social & scouting bar (Hashtags, Like, Comment, Shortlist, Share/Report)
                FeedSocialActionBar(post: post, onTagTap: onTagTap),
                const SizedBox(height: 12),

                // Dedicated View Profile CTA button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => _handleViewProfile(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: const Color(0xFF050A12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('View Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget {
  const _StatMetric({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 8), color: const Color(0xFF1B2A38));
  }
}
