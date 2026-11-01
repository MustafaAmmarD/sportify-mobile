import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';

/// Card container with a colored indicator line and header for overview sections.
class CompanySectionCard extends StatelessWidget {
  const CompanySectionCard({
    super.key,
    required this.title,
    required this.card,
    required this.border,
    required this.green,
    required this.child,
  });

  final String title;
  final Color card;
  final Color border;
  final Color green;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Stat column with an icon, numeric value, and label.
class CompanyUsageStat extends StatelessWidget {
  const CompanyUsageStat(this.label, this.value, this.icon, this.green, {super.key});

  final String label;
  final String value;
  final IconData icon;
  final Color green;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: green, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}

/// Bar chart visualization for check-in activities.
class CompanyActivityBars extends StatelessWidget {
  const CompanyActivityBars({super.key, required this.green});

  final Color green;
  static const _data = [4, 7, 3, 9, 12, 8, 5, 11, 6, 14, 10, 7];

  @override
  Widget build(BuildContext context) {
    final maxV = _data.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_data.length, (i) {
          final h = (_data[i] / maxV) * 56;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 40),
                    height: h,
                    decoration: BoxDecoration(
                      color: i == _data.length - 1
                          ? green
                          : green.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Badge identifying the FIT-Pass tier plan.
class CompanyPlanBadge extends StatelessWidget {
  const CompanyPlanBadge(this.plan, {super.key});

  final String plan;

  Color get _color => switch (plan) {
        'Silver' => const Color(0xFF94A3B8),
        'Gold' => const Color(0xFFF59E0B),
        'Scout' => const Color(0xFF818CF8),
        'Platinum' => const Color(0xFFA78BFA),
        'Bronze' => const Color(0xFFF97316),
        'Digital' => const Color(0xFF38BDF8),
        _ => AppColors.green2,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        plan,
        style: TextStyle(
          color: _color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
