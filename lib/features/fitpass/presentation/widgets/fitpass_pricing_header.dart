import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/fitpass/presentation/models/fitpass_tier.dart';

/// Header above the plan list with audience category chips and Yearly discount toggle.
class FitPassPricingHeader extends StatelessWidget {
  const FitPassPricingHeader({
    super.key,
    required this.yearly,
    required this.onToggle,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final bool yearly;
  final ValueChanged<bool> onToggle;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Membership',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () => onToggle(!yearly),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: yearly ? green.withValues(alpha: 0.15) : card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: yearly ? green : border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      yearly ? Icons.check_circle : Icons.circle_outlined,
                      color: yearly ? green : Colors.white38,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      yearly ? 'Yearly −17%' : 'Pay Yearly −17%',
                      style: TextStyle(
                        color: yearly ? green : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: FitPassTier.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = FitPassTier.categories[i];
              final sel = cat == selectedCategory;
              return GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel ? green : card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? green : border),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: sel ? Colors.black : Colors.white70,
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
