import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Root widget for the Sportify application.
///
/// Configures:
/// - Theme (dark mode based on sportifyplus.de design system)
/// - Localization (EN, DE, AR with RTL)
/// - Navigation (GoRouter — will be added when routes are defined)
class SportifyApp extends StatelessWidget {
  const SportifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportify',
      debugShowCheckedModeBanner: false,

      // ── Theme ──
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050A12),
        // TODO(mustafa): Build full theme in core/theme/ when starting UI
      ),

      // ── Localization ──
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '⚽ Sportify',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scoutingTitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Project scaffold complete ✅',
              style: TextStyle(
                fontSize: 14,
                color: Colors.greenAccent.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
