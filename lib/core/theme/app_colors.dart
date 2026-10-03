import 'package:flutter/material.dart';

/// Brand colors shared by light and dark themes.
///
/// Values come from sportifyplus.de/assets/css/app.css.
abstract final class AppColors {
  /// `--green` — primary brand color (CTA buttons).
  static const Color green = Color(0xFF16A34A);

  /// `--green-2` — lighter green (hover, active states).
  static const Color green2 = Color(0xFF22C55E);

  /// `--green-3` — highlight green (badges, links on dark).
  static const Color green3 = Color(0xFF4ADE80);

  /// Deep green for links/labels on light backgrounds.
  static const Color green700 = Color(0xFF15803D);

  /// `--green-glow` — glow behind primary elements.
  static const Color greenGlow = Color(0x5922C55E);

  /// Dark text used on top of light-green surfaces.
  static const Color onGreen = Color(0xFF04130A);

  /// `--pitch-deep` — the site's `theme-color`.
  static const Color pitchDeep = Color(0xFF0C3020);

  /// `--pitch-gold` — premium / Pro / FIT-Pass Gold accent.
  static const Color gold = Color(0xFFE8BC5C);

  /// `--amber` — warnings, "rumor" transfers.
  static const Color amber = Color(0xFFF59E0B);

  /// `--red` — errors, destructive actions.
  static const Color red = Color(0xFFEF4444);

  /// `--blue` — info.
  static const Color blue = Color(0xFF2563EB);

  /// `--purple` — misc tags.
  static const Color purple = Color(0xFFA78BFA);
}

/// Surface / text palette that changes between light and dark mode.
///
/// Access in widgets with `context.palette` (see [PaletteX]).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Creates a palette.
  const AppPalette({
    required this.bg,
    required this.bg2,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.border2,
    required this.text,
    required this.muted,
    required this.muted2,
    required this.accent,
  });

  /// Dark palette — exact sportifyplus.de tokens.
  static const AppPalette dark = AppPalette(
    bg: Color(0xFF050A12),
    bg2: Color(0xFF091521),
    surface: Color(0xFF0F1D2D),
    surface2: Color(0xFF132338),
    border: Color(0xFF1A2D44),
    border2: Color(0xFF243A56),
    text: Color(0xFFFFFFFF),
    muted: Color(0xFFA1A1AA),
    muted2: Color(0xFF71717A),
    accent: AppColors.green3,
  );

  /// Light palette — derived from the same brand (navy text, green accent).
  static const AppPalette light = AppPalette(
    bg: Color(0xFFF6F8FB),
    bg2: Color(0xFFEEF2F7),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF1F4F9),
    border: Color(0xFFE2E8F0),
    border2: Color(0xFFCBD5E1),
    text: Color(0xFF050A12),
    muted: Color(0xFF52525B),
    muted2: Color(0xFF71717A),
    accent: AppColors.green700,
  );

  /// App background.
  final Color bg;

  /// Secondary background (sections, sheets, nav bar).
  final Color bg2;

  /// Cards.
  final Color surface;

  /// Raised cards, inputs.
  final Color surface2;

  /// Default border.
  final Color border;

  /// Focus / hover border.
  final Color border2;

  /// Primary text.
  final Color text;

  /// Secondary text.
  final Color muted;

  /// Tertiary text / hints.
  final Color muted2;

  /// Readable green for links, selected icons, badges.
  final Color accent;

  @override
  AppPalette copyWith({
    Color? bg,
    Color? bg2,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? border2,
    Color? text,
    Color? muted,
    Color? muted2,
    Color? accent,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      border: border ?? this.border,
      border2: border2 ?? this.border2,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      muted2: muted2 ?? this.muted2,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      border: Color.lerp(border, other.border, t)!,
      border2: Color.lerp(border2, other.border2, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      muted2: Color.lerp(muted2, other.muted2, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

/// Shortcut: `context.palette.surface`.
extension PaletteX on BuildContext {
  /// Current [AppPalette].
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
