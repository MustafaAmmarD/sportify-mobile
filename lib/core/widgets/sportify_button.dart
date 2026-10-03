import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_dimens.dart';

/// Primary, secondary, outline, or text button types.
enum SportifyButtonType { primary, secondary, outline, text }

/// A unified button component for Sportify.
///
/// The primary button uses the brand green glow shadow.
class SportifyButton extends StatelessWidget {
  const SportifyButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.type = SportifyButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  /// The label text.
  final String text;

  /// The action to perform when pressed.
  final VoidCallback? onPressed;

  /// The visual style of the button.
  final SportifyButtonType type;

  /// Whether to show a loading indicator instead of the label/icon.
  final bool isLoading;

  /// Optional icon to show before the text.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final action = isLoading ? null : onPressed;

    switch (type) {
      case SportifyButtonType.primary:
        return Container(
          decoration: BoxDecoration(
            boxShadow: AppShadows.green, // Brand glow
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: FilledButton(onPressed: action, child: _buildChild()),
        );
      case SportifyButtonType.secondary:
        return FilledButton.tonal(onPressed: action, child: _buildChild());
      case SportifyButtonType.outline:
        return OutlinedButton(onPressed: action, child: _buildChild());
      case SportifyButtonType.text:
        return TextButton(onPressed: action, child: _buildChild());
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}
