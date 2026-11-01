import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/news_entities.dart';
import 'news_matches_and_reader.dart';

/// Card rendering a single transfer event with stage badge, fee, and clubs.
class TransferCard extends StatelessWidget {
  const TransferCard({super.key, required this.transfer});

  final TransferActivity transfer;

  int _h(TransferActivity t) => t.id.hashCode.abs();

  String _stageOf(TransferActivity t) {
    final s = t.status.toLowerCase();
    if (s == 'confirmed') return 'Confirmed';
    if (s == 'loan' || s.contains('loan')) return 'Loan deal';
    const rest = ['Rumour', 'Negotiating', 'Advanced talks', 'Here we go'];
    return rest[_h(t) % rest.length];
  }

  Color _stageColor(String s) {
    switch (s) {
      case 'Confirmed':
      case 'Here we go':
        return AppColors.green2;
      case 'Loan deal':
        return const Color(0xFF38BDF8);
      case 'Advanced talks':
      case 'Negotiating':
        return const Color(0xFFF59E0B);
      default:
        return Colors.white54;
    }
  }

  String _ago(DateTime d) => '${DateTime.now().difference(d).inDays.clamp(0, 999)}d ago';

  static const _positions = ['GK', 'CB', 'LB', 'RB', 'CM', 'CAM', 'LW', 'RW', 'ST'];
  static const _nations = ['Venezuela', 'Chile', 'Canada', 'Brazil', 'Spain', 'Germany'];
  static const _kits = [
    Color(0xFFDC2626),
    Color(0xFFEA580C),
    Color(0xFF7C3AED),
    Color(0xFF1F2937),
    Color(0xFF2563EB),
  ];

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    final t = transfer;
    final h = _h(t);
    final stage = _stageOf(t);
    final stageClr = _stageColor(stage);
    final pos = _positions[h % _positions.length];
    final nation = _nations[h % _nations.length];
    final kit = _kits[h % _kits.length];
    final age = 18 + (h % 16);
    final reliability = 65 + (h % 34);

    return GestureDetector(
      onTap: () => openLinkedPlayerProfile(
        context,
        playerName: t.playerName,
        clubName: t.toClub,
        positionCode: pos,
        marketValue: (t.fee != null && t.fee!.isNotEmpty) ? t.fee! : '€5.0M',
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kit.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kit.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    pos,
                    style: TextStyle(color: kit, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.playerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$pos · Age $age · $nation',
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stageClr.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: stageClr.withOpacity(0.4)),
                ),
                child: Text(
                  stage.toUpperCase(),
                  style: TextStyle(
                    color: stageClr,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF070D14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.fromClub,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: green, size: 16),
                ),
                Expanded(
                  child: Text(
                    t.toClub,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (t.fee != null && t.fee!.isNotEmpty) ...[
                Text(
                  t.fee!,
                  style: const TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 12),
              ],
              Text('Reliability: $reliability%', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              const Spacer(),
              if (t.source != null) ...[
                Text(t.source!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(width: 8),
              ],
              Text(_ago(t.date), style: const TextStyle(color: Colors.white24, fontSize: 11)),
              const SizedBox(width: 6),
              const Icon(Icons.open_in_new_rounded, color: green, size: 13),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
