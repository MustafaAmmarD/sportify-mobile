import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/fitpass/presentation/models/fitpass_tier.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_booking_and_training.dart';

/// Expandable subscription tier card with included features and CTA.
class FitPassPlanCard extends StatefulWidget {
  const FitPassPlanCard({
    super.key,
    required this.plan,
    required this.yearly,
  });

  final FitPassTier plan;
  final bool yearly;

  @override
  State<FitPassPlanCard> createState() => _FitPassPlanCardState();
}

class _FitPassPlanCardState extends State<FitPassPlanCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.plan.isPopular;
  }

  double get _price => widget.yearly
      ? double.parse((widget.plan.monthlyPrice * 0.83).toStringAsFixed(0))
      : widget.plan.monthlyPrice;

  @override
  Widget build(BuildContext context) {
    final p = widget.plan;
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: p.isPopular ? green : border,
              width: p.isPopular ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              // ── Header row ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: p.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: p.color.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        p.name[0],
                        style: TextStyle(
                          color: p.color,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (p.isPopular) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'RECOMMENDED',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.subtitle,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '€${_price.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const TextSpan(
                                text: '/mo',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.yearly)
                          Text(
                            'was €${p.monthlyPrice.toInt()}',
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white24,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white38,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Expanded content ──
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: border, height: 1),
                      const SizedBox(height: 12),
                      ...p.features.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: green,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FitPassSessionStore.activatePlan(p.name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Activated ${p.name} Plan (€${_price.toInt()}/mo) on your FIT-Pass!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                p.isPopular ? green : const Color(0xFF1B2A38),
                            foregroundColor:
                                p.isPopular ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Choose ${p.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
