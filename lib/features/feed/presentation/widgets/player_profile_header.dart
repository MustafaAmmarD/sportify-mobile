import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

/// Mobile-first hero header for the Player Scouting Profile screen.
class PlayerProfileHeader extends StatefulWidget {
  const PlayerProfileHeader({super.key, required this.post});

  final FeedPost post;

  @override
  State<PlayerProfileHeader> createState() => _PlayerProfileHeaderState();
}

class _PlayerProfileHeaderState extends State<PlayerProfileHeader> {
  bool _following = false;
  bool _shortlisted = false;

  Color get _statusColor {
    final s = widget.post.availabilityStatus.toLowerCase();
    if (s.contains('loan')) return const Color(0xFF38BDF8);
    if (s.contains('free')) return const Color(0xFFF59E0B);
    return AppColors.green2;
  }

  Widget _buildNavBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: const Color(0xFF070D14).withValues(alpha: 0.75), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
      );

  Widget _buildBadge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.45))),
        child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
      );

  Widget _buildInfoChip(String label, {bool highlight = false}) {
    const green = AppColors.green2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? green.withValues(alpha: 0.12) : const Color(0xFF0E1822),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: highlight ? green.withValues(alpha: 0.45) : const Color(0xFF1B2A38)),
      ),
      child: Text(label, style: TextStyle(color: highlight ? green : Colors.white70, fontSize: 11, fontWeight: highlight ? FontWeight.w800 : FontWeight.w600)),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    Color activeColor = AppColors.green2,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 42,
            decoration: BoxDecoration(
              color: active ? activeColor.withValues(alpha: 0.16) : const Color(0xFF0E1822),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: active ? activeColor : const Color(0xFF1B2A38)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: active ? activeColor : Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: active ? activeColor : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildStatCell(String val, String label, Color color, {bool div = true}) =>
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: div ? const Border(right: BorderSide(color: Color(0xFF1B2A38))) : null,
          ),
          child: Column(
            children: [
              Text(val, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    final formattedMins = NumberFormat.decimalPattern().format(p.minutesPlayed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 145,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?w=1000&q=80',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ColoredBox(color: Color(0xFF0D231A)),
                    errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFF0D231A)),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.45), bg.withValues(alpha: 0.85), bg],
                        stops: const [0.0, 0.72, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _buildNavBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.of(context).pop()),
                  const Spacer(),
                  _buildNavBtn(Icons.ios_share_rounded, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Shared ${p.authorName}\'s profile link')),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 72, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 90,
                        height: 106,
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: green.withValues(alpha: 0.6), width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(imageUrl: p.resolvedThumbnailUrl, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: -6,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: bg, width: 2),
                          ),
                          child: Text('#${p.jerseyNumber}', style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildBadge('${p.positionCode} · ${p.positionFull}', green),
                            _buildBadge('● ${p.availabilityStatus}', _statusColor),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(p.authorName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.4), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('${p.competitionLevel} · ${p.division}', style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip('${p.countryFlag} ${p.nationality}'),
              _buildInfoChip('🎂 ${p.age} yrs'),
              _buildInfoChip('🛡️ ${p.clubName}'),
              if (p.leagueName.isNotEmpty) _buildInfoChip('🏆 ${p.leagueName}'),
              _buildInfoChip('💶 ${p.marketValue}', highlight: true),
              ...p.languages.map((lang) => _buildInfoChip('🗣️ $lang')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildActionBtn(
                icon: _following ? Icons.check_rounded : Icons.add_rounded,
                label: _following ? 'Following' : 'Follow',
                active: _following,
                onTap: () => setState(() => _following = !_following),
              ),
              const SizedBox(width: 10),
              _buildActionBtn(
                icon: _shortlisted ? Icons.star_rounded : Icons.star_border_rounded,
                label: _shortlisted ? 'Shortlisted' : 'Shortlist',
                active: _shortlisted,
                activeColor: const Color(0xFFFACC15),
                onTap: () => setState(() => _shortlisted = !_shortlisted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
            child: Row(
              children: [
                _buildStatCell('${p.goals}', 'GOALS', green),
                _buildStatCell('${p.assists}', 'ASSISTS', green),
                _buildStatCell('${p.appearances}', 'APPEARANCES', Colors.white),
                _buildStatCell(formattedMins, 'MINUTES', Colors.white, div: false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
