import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Displays Player Bio + Playstyle Traits, Current Club, and Transfer Wishes
/// inside the mobile Overview tab of [PlayerProfilePage].
class PlayerOverviewSections extends StatelessWidget {
  const PlayerOverviewSections({super.key, required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const surface = Color(0xFF13202E);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Player Bio & Playstyle Strengths Card ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Player Bio & Playstyle', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Text('${post.preferredFoot} Foot · ${post.heightCm}cm', style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              Text(post.bio, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.55)),
              if (post.traits.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.traits
                      .map((trait) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: green.withValues(alpha: 0.45))),
                            child: Text(trait, style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w700)),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Current Club Card ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Club',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    _ClubShield(
                      initials: post.clubInitials,
                      color: green,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.clubName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            [
                              if (post.clubCity.isNotEmpty) post.clubCity,
                              if (post.clubCountry.isNotEmpty) post.clubCountry,
                            ].join(', '),
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (post.leagueName.isNotEmpty) post.leagueName,
                              post.competitionLevel,
                              post.division,
                            ].join(' · '),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── 3. Transfer Wishes Card ──
        if (post.transferWishes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transfer Wishes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Clubs this player aspires to join',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 14),
                ...post.transferWishes.map(
                  (wish) => _TransferWishTile(wish: wish),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TransferWishTile extends StatelessWidget {
  const _TransferWishTile({required this.wish});

  final TransferWishClub wish;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E);
    const border = Color(0xFF1B2A38);
    final badgeColor = Color(wish.badgeColorHex);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          _ClubShield(initials: wish.initials, color: badgeColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wish.clubName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${wish.country} · ${wish.league} · ${wish.tier}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.north_east_rounded,
            color: Colors.white38,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ClubShield extends StatelessWidget {
  const _ClubShield({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

