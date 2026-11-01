import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Mobile-first Market tab for [PlayerProfilePage].
class PlayerMarketTab extends StatelessWidget {
  const PlayerMarketTab({super.key, required this.post});
  final FeedPost post;

  List<PlayerTransferRecord> _resolveTransfers() {
    final c = post.clubName;
    final pts = post.marketValueHistory;
    final prevFee = pts.length >= 2 ? '€${pts[pts.length - 2].valueMillions.toStringAsFixed(1)}m' : '€2.8m';
    return [
      PlayerTransferRecord(dateLabel: 'Sep 2025', fromClub: '$c II', toClub: c, feeLabel: 'Free', transferType: 'First-Team Promotion'),
      PlayerTransferRecord(dateLabel: 'Aug 2024', fromClub: 'Youth academy', toClub: '$c II', feeLabel: prevFee, transferType: 'Academy Signing'),
    ];
  }

  String _computeDeltaLabel() {
    final pts = post.marketValueHistory;
    if (pts.length >= 2) {
      final diff = pts.last.valueMillions - pts[pts.length - 2].valueMillions;
      if (diff >= 0) {
        final formatted = diff == diff.roundToDouble() ? '${diff.toInt()}' : diff.toStringAsFixed(1);
        return '↑ €${formatted}m';
      }
    }
    return '↑ €1m';
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
    final cardDeco = BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border));
    final transfers = _resolveTransfers();
    final history = post.marketValueHistory;
    final maxVal = history.fold<double>(1.0, (m, p) => p.valueMillions > m ? p.valueMillions : m);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Market Value & Contract Profile Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Market value', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Full market profile', style: TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [green.withValues(alpha: 0.16), surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: green.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(post.marketValue, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(color: green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(_computeDeltaLabel(), style: const TextStyle(color: green, fontSize: 12.5, fontWeight: FontWeight.w900)),
                      ),
                    ]),
                    if (history.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        for (var i = 0; i < history.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          Expanded(child: _ProgressionColumn(point: history[i], ratio: (history[i].valueMillions / maxVal).clamp(0.2, 1.0), isLatest: i == history.length - 1)),
                        ],
                      ]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(children: [
                _MarketSpecTile(icon: Icons.directions_run_rounded, label: 'Foot', value: post.preferredFoot),
                const SizedBox(width: 10),
                _MarketSpecTile(icon: Icons.straighten_rounded, label: 'Height', value: '${post.heightCm} cm'),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const _MarketSpecTile(icon: Icons.verified_user_outlined, label: 'Agent', value: 'Nordic Elite Agency'),
                const SizedBox(width: 10),
                _MarketSpecTile(icon: Icons.event_available_rounded, label: 'Contract expiry', value: 'Jun ${2027 + (post.age % 2)}'),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Transfer History Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transfer history', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Text('${transfers.length} moves', style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < transfers.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _TransferHistoryCard(record: transfers[i]),
              ],
            ],
          ),
        ),

        // ── 3. Target Clubs / Transfer Wishes Card ──
        if (post.transferWishes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardDeco,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Target Clubs & Transfer Wishes', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (var i = 0; i < post.transferWishes.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _WishRow(wish: post.transferWishes[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressionColumn extends StatelessWidget {
  const _ProgressionColumn({required this.point, required this.ratio, required this.isLatest});
  final MarketValuePoint point;
  final double ratio;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return Column(
      children: [
        Text(point.label, style: TextStyle(color: isLatest ? green : Colors.white70, fontSize: 10.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Container(height: 36 * ratio, decoration: BoxDecoration(color: isLatest ? green : Colors.white24, borderRadius: BorderRadius.circular(6))),
        const SizedBox(height: 6),
        Text(point.period, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _MarketSpecTile extends StatelessWidget {
  const _MarketSpecTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1B2A38))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 13, color: Colors.white38), const SizedBox(width: 5), Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600))]),
            const SizedBox(height: 6),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _TransferHistoryCard extends StatelessWidget {
  const _TransferHistoryCard({required this.record});
  final PlayerTransferRecord record;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1B2A38))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.swap_horiz_rounded, color: green, size: 16),
                const SizedBox(width: 6),
                Text(record.dateLabel, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text('· ${record.transferType}', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(record.feeLabel, style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _ClubBox(name: record.fromClub, label: 'FROM', isTarget: false)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward_rounded, color: green, size: 18)),
            Expanded(child: _ClubBox(name: record.toClub, label: 'TO', isTarget: true)),
          ]),
        ],
      ),
    );
  }
}

class _ClubBox extends StatelessWidget {
  const _ClubBox({required this.name, required this.label, required this.isTarget});
  final String name, label;
  final bool isTarget;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF0E1822), borderRadius: BorderRadius.circular(10), border: Border.all(color: isTarget ? green.withValues(alpha: 0.35) : const Color(0xFF1B2A38))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: isTarget ? green : Colors.white38, fontSize: 9, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _WishRow extends StatelessWidget {
  const _WishRow({required this.wish});
  final TransferWishClub wish;

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(wish.badgeColorHex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1B2A38))),
      child: Row(children: [
        Container(
          width: 34, height: 34, alignment: Alignment.center,
          decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(9), border: Border.all(color: badgeColor.withValues(alpha: 0.4))),
          child: Text(wish.initials, style: TextStyle(color: badgeColor, fontSize: 11.5, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(wish.clubName, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
          Text('${wish.league} · ${wish.country}', style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.green2.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(6)),
          child: Text(wish.tier, style: const TextStyle(color: AppColors.green2, fontSize: 10.5, fontWeight: FontWeight.w800)),
        ),
      ]),
    );
  }
}
