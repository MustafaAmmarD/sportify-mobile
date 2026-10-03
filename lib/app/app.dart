import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/localization/cubit/locale_cubit.dart';
import 'package:sportify/core/theme/app_theme.dart';
import 'package:sportify/core/theme/cubit/theme_cubit.dart';
import 'package:sportify/core/widgets/language_switcher.dart';
import 'package:sportify/core/widgets/sportify_button.dart';
import 'package:sportify/core/widgets/sportify_card.dart';
import 'package:sportify/core/widgets/sportify_text_field.dart';

/// Root widget for the Sportify application.
///
/// Configures:
/// - Theme (light + dark, based on sportifyplus.de design system)
/// - Localization (EN, DE, AR with RTL)
/// - Navigation (GoRouter — will be added when routes are defined)
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
              return MaterialApp(
                title: 'Sportify',
                debugShowCheckedModeBanner: false,

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

                // ── Temporary Home (will be replaced by GoRouter) ──
                home: const _TemporaryHomePage(),
              );
            },
          );
        },
      ),
    );
  }
}

/// Placeholder home page to verify the project runs correctly.
///
/// This will be replaced by the actual navigation setup
/// once we build feature screens.
class _TemporaryHomePage extends StatelessWidget {
  const _TemporaryHomePage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final cubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(title: Text('Sportify ${l10n.scoutingTitle}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SportifyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Design System Components', style: text.titleLarge),
                const SizedBox(height: 16),
                const SportifyTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                const SportifyTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 16),
                SportifyButton(text: 'Primary Button', onPressed: () {}),
                const SizedBox(height: 8),
                SportifyButton(
                  text: 'Outline Button',
                  type: SportifyButtonType.outline,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Theme Mode', style: text.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
            ],
            selected: {context.watch<ThemeCubit>().state},
            onSelectionChanged: (s) => cubit.setMode(s.first),
          ),
          const SizedBox(height: 24),
          Text('Language', style: text.titleMedium),
          const SizedBox(height: 8),
          const LanguageSwitcher(),
        ],
      ),
    );
  }
}
