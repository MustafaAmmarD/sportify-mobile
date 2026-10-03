import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportify/core/theme/app_colors.dart';

/// Typography for Sportify.
///
/// - Latin scripts (EN, DE): **Inter** — same font as sportifyplus.de.
/// - Arabic: **Cairo** — Inter has no Arabic glyphs.
abstract final class AppTypography {
  /// Builds the [TextTheme] for [locale] using colors from [p].
  static TextTheme textTheme(Locale locale, AppPalette p) {
    final base = _base(p.text, p.muted);
    return locale.languageCode == 'ar'
        ? GoogleFonts.cairoTextTheme(base)
        : GoogleFonts.interTextTheme(base);
  }

  static TextTheme _base(Color text, Color muted) {
    TextStyle s(double size, FontWeight w, Color c, [double ls = 0]) =>
        TextStyle(fontSize: size, fontWeight: w, color: c, letterSpacing: ls);

    return TextTheme(
      displayLarge: s(40, FontWeight.w800, text, -1),
      displayMedium: s(32, FontWeight.w800, text, -0.5),
      headlineLarge: s(28, FontWeight.w700, text),
      headlineMedium: s(24, FontWeight.w700, text),
      headlineSmall: s(20, FontWeight.w700, text),
      titleLarge: s(18, FontWeight.w600, text),
      titleMedium: s(16, FontWeight.w600, text),
      titleSmall: s(14, FontWeight.w600, text),
      bodyLarge: s(16, FontWeight.w400, text),
      bodyMedium: s(14, FontWeight.w400, muted),
      bodySmall: s(12, FontWeight.w400, muted),
      labelLarge: s(15, FontWeight.w600, text),
      labelMedium: s(13, FontWeight.w500, muted),
      labelSmall: s(11, FontWeight.w500, muted, 0.4),
    );
  }
}
