import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';

/// Spacing scale (4pt grid).
abstract final class AppSpacing {
  /// 4
  static const double xs = 4;

  /// 8
  static const double sm = 8;

  /// 12
  static const double md = 12;

  /// 16
  static const double lg = 16;

  /// 24
  static const double xl = 24;

  /// 32
  static const double xxl = 32;

  /// Default horizontal page padding.
  static const EdgeInsetsDirectional page = EdgeInsetsDirectional.symmetric(
    horizontal: lg,
  );
}

/// Corner radii — mirrors `--radius-sm`, `--radius`, `--radius-lg`.
abstract final class AppRadius {
  /// `--radius-sm` (10) — chips, small inputs.
  static const double sm = 10;

  /// `--radius` (16) — cards, buttons, inputs.
  static const double md = 16;

  /// `--radius-lg` (24) — hero media, sheets.
  static const double lg = 24;

  /// Fully rounded (pills, avatars).
  static const double pill = 999;
}

/// Shadows — mirrors `--shadow` and `--shadow-green`.
abstract final class AppShadows {
  /// `--shadow` — default elevated card.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0xB3000000),
      offset: Offset(0, 18),
      blurRadius: 40,
      spreadRadius: -18,
    ),
  ];

  /// `--shadow-green` — primary CTA glow.
  static const List<BoxShadow> green = [
    BoxShadow(
      color: AppColors.greenGlow,
      offset: Offset(0, 14),
      blurRadius: 40,
      spreadRadius: -14,
    ),
  ];
}
