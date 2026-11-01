import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';

class _FeatureItem {
  const _FeatureItem(this.icon, this.label, this.desc);
  final IconData icon;
  final String label;
  final String desc;
}

const _features = <_FeatureItem>[
  _FeatureItem(
    Icons.fitness_center_rounded,
    'Partner Gyms',
    'Access gyms & performance centers',
  ),
  _FeatureItem(
    Icons.sports_soccer_rounded,
    'Pro Training',
    'Position-specific coach plans',
  ),
  _FeatureItem(
    Icons.spa_rounded,
    'Recovery & Physio',
    'Pools, sauna & wellness access',
  ),
  _FeatureItem(
    Icons.ondemand_video_rounded,
    'Tactical Courses',
    'On-demand mindset & skill lessons',
  ),
];

/// Compact horizontal perks carousel for FIT-Pass memberships.
class FitPassFeaturesSection extends StatelessWidget {
  const FitPassFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final f = _features[i];
          return Container(
            width: 210,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.icon, color: green, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f.desc,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
