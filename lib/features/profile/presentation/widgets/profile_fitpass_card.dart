import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Promotional card showcasing FIT-Pass status & partner access on the profile.
class ProfileFitPassCard extends StatelessWidget {
  const ProfileFitPassCard({super.key});

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C2A1E), Color(0xFF0E1822)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: green.withOpacity(0.4)),
            ),
            child: const Icon(Icons.fitness_center, color: green, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock FIT-Pass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Train at 500+ partner gyms and clubs.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'View Plans',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
