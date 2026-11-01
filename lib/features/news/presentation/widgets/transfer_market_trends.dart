import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/news_entities.dart';

/// Top header banner and market volume trends for TransfersPage.
class TransferHeroHeader extends StatelessWidget {
  const TransferHeroHeader({
    super.key,
    required this.totalCount,
    required this.totalValueM,
    required this.confirmedCount,
  });

  final int totalCount;
  final double totalValueM;
  final int confirmedCount;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: green.withOpacity(0.5)),
              ),
              child: const Text(
                'TRANSFER HUB',
                style: TextStyle(
                  color: green,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const Spacer(),
            const Text('LIVE UPDATES',
                style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Live Transfer Market',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        const Text(
          'Real-time rumours, confirmed moves, and fee tracker.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _Stat('Active Moves', '$totalCount', Colors.white, card, border),
            const SizedBox(width: 8),
            _Stat('Total Volume', '€${totalValueM.toStringAsFixed(0)}M', green, card, border),
            const SizedBox(width: 8),
            _Stat('Confirmed', '$confirmedCount', const Color(0xFF38BDF8), card, border),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.val, this.c, this.card, this.border);
  final String label;
  final String val;
  final Color c;
  final Color card;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(color: c, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

/// Visual horizontal bars showing top deal spenders in the market.
class TransferMarketTrends extends StatelessWidget {
  const TransferMarketTrends({super.key, required this.topTransfers});

  final List<TransferActivity> topTransfers;

  double _feeM(TransferActivity t) {
    final m = RegExp(r'[\d.,]+').firstMatch(t.fee ?? '');
    if (m == null) return 0;
    return double.tryParse(m.group(0)!.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (topTransfers.isEmpty) return const SizedBox.shrink();
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    final maxFee = topTransfers.map(_feeM).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biggest Deals Tracker',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...topTransfers.take(4).map((t) {
            final f = _feeM(t);
            final ratio = maxFee > 0 ? (f / maxFee).clamp(0.05, 1.0) : 0.1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.playerName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(t.fee ?? '', style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: const Color(0xFF070D14),
                      valueColor: const AlwaysStoppedAnimation(green),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
