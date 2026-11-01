import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

/// Unified mobile card combining the AI Profile Rating gauge,
/// 6-axis hexagonal radar chart, and 2x3 Key Attributes progress grid.
class PlayerRadarCard extends StatelessWidget {
  const PlayerRadarCard({super.key, required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const surface = Color(0xFF13202E);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    final metrics = post.radarStats.entries;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          value: (post.aiRating.clamp(0, 100)) / 100,
                          strokeWidth: 5,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(green),
                        ),
                      ),
                      Text(
                        '${post.aiRating}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Profile Rating',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Output · Style · Potential',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: green.withValues(alpha: 0.45)),
                  ),
                  child: Text(
                    '${post.fitScore} FIT',
                    style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Player Radar & Key Attributes',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 260,
              height: 230,
              child: CustomPaint(painter: _RadarChartPainter(metrics: metrics)),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 14,
              mainAxisExtent: 38,
            ),
            itemBuilder: (_, i) {
              final item = metrics[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      Text('${item.$2}', style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (item.$2.clamp(0, 100)) / 100,
                      minHeight: 6,
                      backgroundColor: const Color(0xFF182635),
                      valueColor: const AlwaysStoppedAnimation(green),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  const _RadarChartPainter({required this.metrics});

  final List<(String, int)> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final sides = metrics.length;
    if (sides < 3) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    const green = AppColors.green2;

    final gridPaint = Paint()
      ..color = const Color(0xFF1F3347)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var ring = 1; ring <= 4; ring++) {
      final r = radius * (ring / 4);
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final angle = -math.pi / 2 + (2 * math.pi * i / sides);
        final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    final dataPath = Path();
    final vertexPoints = <Offset>[];

    for (var i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / sides);
      final outerPt = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(center, outerPt, gridPaint);

      final val = (metrics[i].$2.clamp(0, 100)) / 100.0;
      final dataPt = Offset(center.dx + radius * val * math.cos(angle), center.dy + radius * val * math.sin(angle));
      vertexPoints.add(dataPt);
      if (i == 0) {
        dataPath.moveTo(dataPt.dx, dataPt.dy);
      } else {
        dataPath.lineTo(dataPt.dx, dataPt.dy);
      }

      final labelDist = radius + 24;
      final labelCenter = Offset(center.dx + labelDist * math.cos(angle), center.dy + labelDist * math.sin(angle));
      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${metrics[i].$1}\n',
              style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: '${metrics[i].$2}',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(labelCenter.dx - tp.width / 2, labelCenter.dy - tp.height / 2));
    }
    dataPath.close();

    canvas.drawPath(dataPath, Paint()..color = green.withValues(alpha: 0.22)..style = PaintingStyle.fill);
    canvas.drawPath(dataPath, Paint()..color = green..style = PaintingStyle.stroke..strokeWidth = 2);

    final dotPaint = Paint()..color = green;
    for (final pt in vertexPoints) {
      canvas.drawCircle(pt, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) => oldDelegate.metrics != metrics;
}
