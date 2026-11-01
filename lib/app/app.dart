import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/localization/cubit/locale_cubit.dart';
import 'package:sportify/core/theme/app_theme.dart';
import 'package:sportify/core/theme/cubit/theme_cubit.dart';

/// Root widget for the Sportify application.
///
/// Configures:
/// - Theme (light + dark, based on sportifyplus.de design system)
/// - Localization (EN, DE, AR with RTL)
/// - Navigation (GoRouter, see `app_router.dart`)
class SportifyApp extends StatelessWidget {
  /// Creates the root app widget.
  const SportifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp.router(
                title: 'Sportify',
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,

                // ── Theme (Inter for EN/DE, Cairo for AR) ──
                themeMode: mode,
                theme: AppTheme.light(locale),
                darkTheme: AppTheme.dark(locale),
                builder: (context, child) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Theme(
                    data:
                        isDark ? AppTheme.dark(locale) : AppTheme.light(locale),
                    child: child!,
                  );
                },

                // ── Localization ──
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
