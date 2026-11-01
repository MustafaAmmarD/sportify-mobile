import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';

/// Horizontal banner showing player physical and positional metrics.
class ProfileStatsBanner extends StatelessWidget {
  const ProfileStatsBanner({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);

    final stats = <String, String>{
      if (profile.position != null) 'Position': profile.position!,
      if (profile.nationality != null) 'Nation': profile.nationality!,
      if (profile.preferredFoot != null) 'Foot': profile.preferredFoot!,
      if (profile.heightCm != null) 'Height': '${profile.heightCm} cm',
      if (profile.weightKg != null) 'Weight': '${profile.weightKg} kg',
    };

    if (stats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.entries.map((e) {
          return Column(
            children: [
              Text(
                e.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                e.key,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
