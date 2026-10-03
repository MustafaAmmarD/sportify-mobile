import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_dimens.dart';

/// Standard card container for Sportify items (players, matches, etc.).
class SportifyCard extends StatelessWidget {
  const SportifyCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
  });

  /// The content of the card.
  final Widget child;

  /// Inner padding around the content.
  final EdgeInsetsGeometry padding;

  /// Optional tap handler (adds ink ripple).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);

    if (onTap != null) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return Card(child: content);
  }
}
