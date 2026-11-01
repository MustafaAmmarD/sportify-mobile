import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/profile.dart';

/// Card summarizing Football CV attributes: position, nation, foot, height, weight.
class ProfileCvCard extends StatelessWidget {
  const ProfileCvCard({
    super.key,
    required this.profile,
    required this.l10n,
  });

  final Profile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    Widget row(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: green, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    final rows = <Widget>[
      if (profile.position != null)
        row(Icons.sports_soccer, l10n.profilePosition, profile.position!),
      if (profile.nationality != null)
        row(Icons.flag_outlined, l10n.profileNationality, profile.nationality!),
      if (profile.preferredFoot != null)
        row(Icons.directions_run_outlined, l10n.profilePreferredFoot, profile.preferredFoot!),
      if (profile.heightCm != null)
        row(Icons.height, l10n.profileHeight, '${profile.heightCm} cm'),
      if (profile.weightKg != null)
        row(Icons.monitor_weight_outlined, l10n.profileWeight, '${profile.weightKg} kg'),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

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
                height: 18,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Football CV',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          ...rows.expand((w) => [
                const Divider(color: border, height: 1),
                w,
              ]),
        ],
      ),
    );
  }
}
