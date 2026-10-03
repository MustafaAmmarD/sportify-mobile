import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/core/theme/app_dimens.dart';
import 'package:sportify/core/theme/app_typography.dart';

/// Builds Sportify [ThemeData] for light and dark mode.
abstract final class AppTheme {
  /// Dark theme (default brand look, matches sportifyplus.de).
  static ThemeData dark(Locale locale) =>
      _build(Brightness.dark, AppPalette.dark, locale);

  /// Light theme (same brand, light surfaces).
  static ThemeData light(Locale locale) =>
      _build(Brightness.light, AppPalette.light, locale);

  static ThemeData _build(Brightness b, AppPalette p, Locale locale) {
    final isDark = b == Brightness.dark;
    final textTheme = AppTypography.textTheme(locale, p);

    final colorScheme = ColorScheme(
      brightness: b,
      primary: AppColors.green,
      onPrimary: Colors.white,
      secondary: p.accent,
      onSecondary: isDark ? AppColors.onGreen : Colors.white,
      tertiary: AppColors.gold,
      onTertiary: AppColors.onGreen,
      error: AppColors.red,
      onError: Colors.white,
      surface: p.surface,
      onSurface: p.text,
      surfaceContainerHighest: p.surface2,
      outline: p.border,
      outlineVariant: p.border2,
    );

    final roundedMd = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    Color selected(Set<WidgetState> s) =>
        s.contains(WidgetState.selected) ? p.accent : p.muted;

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.bg,
      textTheme: textTheme,
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: p.bg.withValues(alpha: 0.92),
        foregroundColor: p.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: p.border),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: p.surface2,
          disabledForegroundColor: p.muted2,
          minimumSize: const Size.fromHeight(52),
          shape: roundedMd,
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.text,
          side: BorderSide(color: p.border2),
          minimumSize: const Size.fromHeight(52),
          shape: roundedMd,
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accent,
          textStyle: textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface2,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        hintStyle: textTheme.bodyMedium?.copyWith(color: p.muted2),
        labelStyle: textTheme.bodyMedium,
        border: inputBorder(p.border),
        enabledBorder: inputBorder(p.border),
        focusedBorder: inputBorder(AppColors.green2, 1.5),
        errorBorder: inputBorder(AppColors.red),
        focusedErrorBorder: inputBorder(AppColors.red, 1.5),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: p.surface2,
        selectedColor: AppColors.green.withValues(alpha: 0.18),
        side: BorderSide(color: p.border),
        labelStyle: textTheme.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.bg2,
        indicatorColor: AppColors.green.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => textTheme.labelSmall?.copyWith(color: selected(s)),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: selected(s)),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.bg2,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),

      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.surface2,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.text),
        behavior: SnackBarBehavior.floating,
        shape: roundedMd,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green2,
      ),
    );
  }
}
