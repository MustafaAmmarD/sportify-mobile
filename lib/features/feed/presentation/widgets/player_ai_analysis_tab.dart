import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

/// Dynamic backend-ready model for a player's AI Performance & Health report.
class PlayerAiAnalysis extends Equatable {
  const PlayerAiAnalysis({
    required this.generatedDate,
    required this.performanceScore,
    required this.healthStatus,
    required this.fitnessIndex,
    required this.injuryRiskPercent,
    required this.injuryRiskLevel,
    required this.insights,
  });

  factory PlayerAiAnalysis.fromJson(Map<String, dynamic> json) {
    final rawInsights = json['insights'] as List<dynamic>?;
    return PlayerAiAnalysis(
      generatedDate: (json['generatedDate'] ?? json['generated_date'] ?? 'Oct 28, 2026').toString(),
      performanceScore: ((json['performanceScore'] ?? json['performance_score'] ?? 97) as num).toInt(),
      healthStatus: (json['healthStatus'] ?? json['health_status'] ?? 'Fit').toString(),
      fitnessIndex: ((json['fitnessIndex'] ?? json['fitness_index'] ?? 96) as num).toInt(),
      injuryRiskPercent: ((json['injuryRiskPercent'] ?? json['injury_risk_percent'] ?? 23) as num).toInt(),
      injuryRiskLevel: (json['injuryRiskLevel'] ?? json['injury_risk_level'] ?? 'LOW').toString(),
      insights: rawInsights != null ? rawInsights.map((e) => e.toString()).toList() : const [],
    );
  }

  factory PlayerAiAnalysis.fromPost(FeedPost post) {
    final sortedAttrs = [...post.radarStats.entries]..sort((a, b) => b.$2.compareTo(a.$2));
    final topTwo = sortedAttrs.take(2).map((e) => e.$1).join(', ');
    final score = post.fitScore.clamp(84, 99);
    final fitness = post.aiRating.clamp(82, 99);
    final risk = (100 - fitness + 19).clamp(12, 32);

    return PlayerAiAnalysis(
      generatedDate: 'Oct 28, 2026',
      performanceScore: score,
      healthStatus: 'Fit',
      fitnessIndex: fitness,
      injuryRiskPercent: risk,
      injuryRiskLevel: risk < 30 ? 'LOW' : 'MODERATE',
      insights: [
        'Standout attributes: $topTwo.',
        'Strong fit for ${post.positionFull} role (fit score $score).',
        'High attacking output: ${post.goals + post.assists} G+A in ${post.appearances} appearances (${post.minutesPlayed} mins).',
        'Sustained match sharpness with a $fitness/100 fitness index and $risk% low injury risk.',
      ],
    );
  }

  final String generatedDate, healthStatus, injuryRiskLevel;
  final int performanceScore, fitnessIndex, injuryRiskPercent;
  final List<String> insights;

  Map<String, dynamic> toJson() => {'generatedDate': generatedDate, 'performanceScore': performanceScore, 'healthStatus': healthStatus, 'fitnessIndex': fitnessIndex, 'injuryRiskPercent': injuryRiskPercent, 'injuryRiskLevel': injuryRiskLevel, 'insights': insights};

  @override
  List<Object?> get props => [generatedDate, performanceScore, healthStatus, fitnessIndex, injuryRiskPercent, injuryRiskLevel, insights];
}

/// Mobile-first AI Analysis tab for [PlayerProfilePage].
class PlayerAiAnalysisTab extends StatelessWidget {
  const PlayerAiAnalysisTab({super.key, required this.post});
  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38);
    const green = AppColors.green2, purple = Color(0xFFA78BFA);
    final ai = PlayerAiAnalysis.fromPost(post);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Header Bar (Badge + Full Report CTA) ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF231E3D), borderRadius: BorderRadius.circular(20), border: Border.all(color: purple.withValues(alpha: 0.35))),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.auto_awesome_rounded, color: purple, size: 12),
                  SizedBox(width: 5),
                  Text('SPORTIFY AI ANALYSIS', style: TextStyle(color: purple, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.6)),
                ]),
              ),
              GestureDetector(
                onTap: () => _showFullReportSheet(context, ai),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: border)),
                  child: const Text('Full report', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('AI Performance & Health', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('Generated ${ai.generatedDate}', style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          // ── 2. Performance Score Ring + Health Status Mobile Row ──
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  height: 154,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PERFORMANCE SCORE', style: TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      SizedBox(
                        width: 86,
                        height: 86,
                        child: CustomPaint(
                          painter: _ScoreRingPainter(score: ai.performanceScore, color: green),
                          child: Center(
                            child: Text('${ai.performanceScore}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Container(
                  height: 154,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HEALTH STATUS', style: TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: green.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(width: 7, height: 7, decoration: const BoxDecoration(color: green, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(ai.healthStatus, style: const TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text('Fitness index: ', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('${ai.fitnessIndex}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── 3. Injury Risk Bar Card ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('INJURY RISK', style: TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (ai.injuryRiskPercent / 100.0).clamp(0.05, 1.0),
                    minHeight: 8,
                    backgroundColor: const Color(0xFF1E2D3D),
                    valueColor: const AlwaysStoppedAnimation<Color>(green),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${ai.injuryRiskPercent}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    Text(ai.injuryRiskLevel, style: const TextStyle(color: green, fontSize: 11.5, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ── 4. Key Insights List ──
          const Text('Key insights', style: TextStyle(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          for (var i = 0; i < ai.insights.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: green, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(ai.insights[i], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.35)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFullReportSheet(BuildContext context, PlayerAiAnalysis ai) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0E1822),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Text('${post.authorName} · Full AI Scouting Verdict', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(
              'Sportify AI rates ${post.authorName} at ${ai.performanceScore}/100 for the ${post.positionFull} role at ${post.clubName}, '
              'combining a ${ai.fitnessIndex}/100 fitness index with ${ai.injuryRiskPercent}% (${ai.injuryRiskLevel}) injury risk and a market valuation of ${post.marketValue}.',
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 16),
            for (final item in ai.insights)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $item', style: const TextStyle(color: AppColors.green2, fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({required this.score, required this.color});
  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;
    final trackPaint = Paint()
      ..color = const Color(0xFF1E2D3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.5;
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    final sweep = 2 * math.pi * (score.clamp(0, 100) / 100.0);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter old) => old.score != score || old.color != color;
}
