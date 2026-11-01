import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_dimens.dart';

/// Progress indicator header showing active step and labels for registration.
class RegisterStepHeader extends StatelessWidget {
  const RegisterStepHeader({
    super.key,
    required this.current,
    required this.labels,
  });

  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: i <= current
                          ? scheme.primary
                          : scheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    labels[i],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: i <= current
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (i < labels.length - 1) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
