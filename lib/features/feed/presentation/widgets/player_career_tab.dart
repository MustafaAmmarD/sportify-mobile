import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Mobile-first Career tab for [PlayerProfilePage].
class PlayerCareerTab extends StatelessWidget {
  const PlayerCareerTab({super.key, required this.post});
  final FeedPost post;

  List<PlayerCareerEntry> _resolveCareer() {
    final p = post;
    final prevApps = (p.appearances * 0.7).round().clamp(8, 30);
    final prevGoals = p.goals >= 10 ? 10 : (p.goals * 0.75).round();
    final prevAssists = (p.assists * 0.65).round();
    final youthApps = (p.appearances * 0.85).round().clamp(12, 28);
    final youthGoals = (p.goals * 0.55).round();

    return [
      PlayerCareerEntry(season: '2024–25', clubName: p.clubName, competition: '${p.leagueName.isNotEmpty ? p.leagueName : p.clubCountry} · ${p.division}', appearances: p.appearances, goals: p.goals, assists: p.assists, roleTag: p.availabilityStatus, isCurrent: true),
      PlayerCareerEntry(season: '2023–24', clubName: '${p.clubName} II', competition: '${p.clubCountry} · Reserve League', appearances: prevApps, goals: prevGoals, assists: prevAssists, roleTag: 'B-Team Breakthrough'),
      PlayerCareerEntry(season: '2022–23', clubName: '${p.clubName} U19', competition: '${p.clubCountry} · U19 Elite Division', appearances: youthApps, goals: youthGoals, assists: (p.assists * 0.5).round(), roleTag: 'Youth Academy'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), border = Color(0xFF1B2A38), green = AppColors.green2;
    final entries = _resolveCareer();
    final totalApps = entries.fold<int>(0, (s, e) => s + e.appearances);
    final totalGoals = entries.fold<int>(0, (s, e) => s + e.goals);
    final totalAssists = entries.fold<int>(0, (s, e) => s + e.assists);
    final cardDeco = BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Career Totals Banner Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: green, size: 18),
                      SizedBox(width: 8),
                      Text('Career Totals', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                    child: Text('${entries.length} Seasons', style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _TotalTile(value: '$totalApps', label: 'TOTAL APPS', color: Colors.white),
                  const SizedBox(width: 8),
                  _TotalTile(value: '$totalGoals', label: 'TOTAL GOALS', color: green),
                  const SizedBox(width: 8),
                  _TotalTile(value: '$totalAssists', label: 'ASSISTS', color: const Color(0xFF38BDF8)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Vertical Career History Timeline Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Career History', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              for (var i = 0; i < entries.length; i++)
                _TimelineRow(
                  entry: entries[i],
                  clubInitials: post.clubInitials,
                  isLast: i == entries.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 3. Pathway & Contract Status Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Scouting Pathway & Status', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _PathwayCell(label: 'STATUS', value: post.availabilityStatus, accent: green),
                  const SizedBox(width: 10),
                  _PathwayCell(label: 'COMPETITION TIER', value: post.competitionLevel, accent: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _PathwayCell(label: 'MARKET VALUE', value: post.marketValue, accent: green),
                  const SizedBox(width: 10),
                  _PathwayCell(
                    label: 'TOP TARGET CLUB',
                    value: post.transferWishes.isNotEmpty ? post.transferWishes.first.clubName : 'European Top 5',
                    accent: const Color(0xFFFACC15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.clubInitials, required this.isLast});
  final PlayerCareerEntry entry;
  final String clubInitials;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
    return Stack(
      children: [
        if (!isLast)
          Positioned(
            top: 18,
            bottom: 0,
            left: 6,
            width: 2,
            child: ColoredBox(color: entry.isCurrent ? green.withValues(alpha: 0.45) : border),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: entry.isCurrent ? green : const Color(0xFF0E1822),
                shape: BoxShape.circle,
                border: Border.all(color: entry.isCurrent ? green : Colors.white38, width: 2.5),
                boxShadow: entry.isCurrent ? [BoxShadow(color: green.withValues(alpha: 0.45), blurRadius: 8)] : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: entry.isCurrent ? green.withValues(alpha: 0.45) : border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: entry.isCurrent ? green.withValues(alpha: 0.16) : const Color(0xFF0E1822),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(entry.season, style: TextStyle(color: entry.isCurrent ? green : Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w900)),
                        ),
                        Text(entry.roleTag, style: TextStyle(color: entry.isCurrent ? green : Colors.white54, fontSize: 10.5, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: green.withValues(alpha: 0.35)),
                          ),
                          child: Text(clubInitials, style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.clubName, style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(entry.competition, style: const TextStyle(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF0E1822), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${entry.appearances} apps', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                          const Text('·', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900)),
                          Text('${entry.goals} goals', style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w800)),
                          const Text('·', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900)),
                          Text('${entry.assists} assists', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.value, required this.label, required this.color});
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1B2A38))),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _PathwayCell extends StatelessWidget {
  const _PathwayCell({required this.label, required this.value, required this.accent});
  final String label, value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1B2A38))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
