import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Mobile-first Statistics tab for [PlayerProfilePage].
class PlayerStatisticsTab extends StatelessWidget {
  const PlayerStatisticsTab({super.key, required this.post});
  final FeedPost post;

  List<MarketValuePoint> get _resolvedHistory {
    if (post.marketValueHistory.isNotEmpty) return post.marketValueHistory;
    final rawNum = double.tryParse(post.marketValue.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 5.0;
    return [
      MarketValuePoint(period: '2022', valueMillions: double.parse((rawNum * 0.45).toStringAsFixed(1))),
      MarketValuePoint(period: '2023', valueMillions: double.parse((rawNum * 0.65).toStringAsFixed(1))),
      MarketValuePoint(period: '2024', valueMillions: double.parse((rawNum * 0.82).toStringAsFixed(1))),
      MarketValuePoint(period: '2025', valueMillions: rawNum, formattedLabel: post.marketValue),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38);
    const green = AppColors.green2, blue = Color(0xFF38BDF8);
    final attributes = post.radarStats.entries;
    final history = _resolvedHistory;
    final formattedMins = NumberFormat.decimalPattern().format(post.minutesPlayed);
    final totalGA = post.goalContributions;
    final goalRatio = totalGA > 0 ? post.goals / totalGA : 0.5;
    final cardDeco = BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Season Output & Per-90 Efficiency Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Season Output', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(8)),
                    child: Text('${post.contributionsPer90.toStringAsFixed(2)} G+A / 90', style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _OutputBox(value: '${post.goals}', label: 'GOALS', color: green),
                  const SizedBox(width: 10),
                  _OutputBox(value: '${post.assists}', label: 'ASSISTS', color: green),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _OutputBox(value: '${post.appearances}', label: 'APPEARANCES', color: Colors.white),
                  const SizedBox(width: 10),
                  _OutputBox(value: formattedMins, label: 'MINUTES', color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _EfficiencyTile(label: 'GOALS / 90', value: post.goalsPer90.toStringAsFixed(2)),
                  const SizedBox(width: 8),
                  _EfficiencyTile(label: 'ASSISTS / 90', value: post.assistsPer90.toStringAsFixed(2)),
                  const SizedBox(width: 8),
                  _EfficiencyTile(label: 'G+A', value: '$totalGA', highlight: true),
                ],
              ),
              if (totalGA > 0) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 7,
                    child: Row(
                      children: [
                        Expanded(flex: (goalRatio * 100).round().clamp(1, 99), child: const ColoredBox(color: green)),
                        Expanded(flex: ((1 - goalRatio) * 100).round().clamp(1, 99), child: const ColoredBox(color: blue)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Attribute Breakdown Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attribute Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              ...attributes.map((attr) {
                final score = attr.$2.clamp(0, 100);
                final isElite = score >= 90;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(attr.$1, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              isElite ? 'ELITE' : (score >= 80 ? 'STRONG' : 'SOLID'),
                              style: TextStyle(color: isElite ? green : Colors.white54, fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const Spacer(),
                          Text('$score', style: const TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0xFF182635),
                          valueColor: const AlwaysStoppedAnimation(green),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 3. Market Value Trend Area Chart Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up_rounded, color: green, size: 18),
                      SizedBox(width: 8),
                      Text('Market Value Trend', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: green.withValues(alpha: 0.45))),
                    child: Text('Now ${post.marketValue}', style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(height: 185, width: double.infinity, child: CustomPaint(painter: _MarketTrendChartPainter(points: history))),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutputBox extends StatelessWidget {
  const _OutputBox({required this.value, required this.label, required this.color});
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFF13202E), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1B2A38))),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
          ],
        ),
      ),
    );
  }
}

class _EfficiencyTile extends StatelessWidget {
  const _EfficiencyTile({required this.label, required this.value, this.highlight = false});
  final String label, value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: highlight ? green.withValues(alpha: 0.12) : const Color(0xFF13202E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: highlight ? green.withValues(alpha: 0.45) : const Color(0xFF1B2A38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: highlight ? green : Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _MarketTrendChartPainter extends CustomPainter {
  const _MarketTrendChartPainter({required this.points});
  final List<MarketValuePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const green = AppColors.green2, padX = 18.0, topPad = 24.0, bottomPad = 26.0;
    final chartW = size.width - padX * 2, chartH = size.height - topPad - bottomPad;
    final values = points.map((p) => p.valueMillions).toList();
    final minV = (values.reduce(math.min) * 0.75).clamp(0.0, double.infinity);
    final maxV = values.reduce(math.max) * 1.12;
    final range = (maxV - minV) <= 0 ? 1.0 : (maxV - minV);

    final gridPaint = Paint()..color = const Color(0xFF1B2A38)..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = topPad + chartH * (i / 3);
      canvas.drawLine(Offset(padX, y), Offset(size.width - padX, y), gridPaint);
    }

    final coords = [
      for (var i = 0; i < points.length; i++)
        Offset(
          points.length == 1 ? padX + chartW / 2 : padX + chartW * (i / (points.length - 1)),
          topPad + chartH * (1 - ((points[i].valueMillions - minV) / range)),
        ),
    ];

    final linePath = Path()..moveTo(coords.first.dx, coords.first.dy);
    for (var i = 1; i < coords.length; i++) {
      linePath.lineTo(coords[i].dx, coords[i].dy);
    }
    final areaPath = Path.from(linePath)..lineTo(coords.last.dx, topPad + chartH)..lineTo(coords.first.dx, topPad + chartH)..close();

    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [green.withValues(alpha: 0.28), green.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, topPad, size.width, chartH)),
    );
    canvas.drawPath(linePath, Paint()..color = green..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);

    for (var i = 0; i < coords.length; i++) {
      final pt = coords[i];
      canvas.drawCircle(pt, 5, Paint()..color = const Color(0xFF0E1822));
      canvas.drawCircle(pt, 5, Paint()..color = green..style = PaintingStyle.stroke..strokeWidth = 2.5);
      final valTp = TextPainter(text: TextSpan(text: points[i].label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)), textDirection: TextDirection.ltr)..layout();
      valTp.paint(canvas, Offset(pt.dx - valTp.width / 2, pt.dy - 20));
      final yrTp = TextPainter(text: TextSpan(text: points[i].period, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600)), textDirection: TextDirection.ltr)..layout();
      yrTp.paint(canvas, Offset(pt.dx - yrTp.width / 2, topPad + chartH + 8));
    }
  }

  @override
  bool shouldRepaint(covariant _MarketTrendChartPainter oldDelegate) => oldDelegate.points != points;
}
