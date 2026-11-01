import 'package:flutter/material.dart';

/// Instant trilingual (EN / DE / AR) lookup helper for Phase 1 modules.
///
/// Works immediately on Hot Reload without waiting for `flutter gen-l10n`,
/// while staying 100% synchronized with `LocaleCubit` (`Localizations.localeOf(context)`).
class SportifyL10n {
  SportifyL10n(this.lang);

  final String lang;

  static SportifyL10n of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    return SportifyL10n(code);
  }

  String _pick(String en, String de, String ar) {
    if (lang == 'de') return de;
    if (lang == 'ar') return ar;
    return en;
  }

  // ── Football Hub (News / Transfers / Matches) ──
  String get hubTitle => _pick('Football Hub', 'Fußball-Hub', 'مركز كرة القدم');
  String get hubTabNews => _pick('News', 'News', 'الأخبار');
  String get hubTabTransfers => _pick('Transfers', 'Transfers', 'الانتقالات');
  String get hubTabMatches => _pick('Matches', 'Spiele', 'المباريات');

  // ── FIT-Pass ──
  String get fitPassTabVenues => _pick('Venues & Map', 'Partner & Karte', 'الأندية والخريطة');
  String get fitPassTabTraining => _pick('Training', 'Training', 'التدريب');
  String get fitPassTabPlans => _pick('Plans', 'Pakete', 'الباقات');
  String get fitPassCheckIn => _pick('Check-in with QR', 'QR-Check-in', 'تسجيل الدخول عبر QR');

  // ── Feed & Guest Mode ──
  String get feedPostAction => _pick('Post', 'Posten', 'نشر');
  String get feedGuestBanner => _pick(
        'Guest Mode — Browse feed & news freely',
        'Gastmodus — Feed & News frei entdecken',
        'وضع الزائر — تصفح الخلاصة والأخبار بحرية',
      );

  // ── Profile, Network & GDPR Settings ──
  String get profileMyNetwork => _pick('My Scouting Network', 'Mein Scouting-Netzwerk', 'شبكة الكشافة الخاصة بي');
  String get profileMessages => _pick('Messages & Inquiries', 'Nachrichten & Anfragen', 'الرسائل والاستفسارات');
  String get profileCompanyPortal => _pick('Club & Company Portal', 'Vereins- & Firmenportal', 'بوابة النادي والشركة');
  String get profileSettingsGdpr => _pick(
        'Settings, Language & GDPR',
        'Einstellungen, Sprache & DSGVO',
        'الإعدادات واللغة والخصوصية (GDPR)',
      );
  String get profileExportGdpr => _pick(
        'Export Personal Data (GDPR)',
        'Persönliche Daten exportieren (DSGVO)',
        'تصدير البيانات الشخصية (GDPR)',
      );
  String get profileDeleteAccount => _pick(
        'Delete Account Permanently',
        'Konto dauerhaft löschen',
        'حذف الحساب نهائياً',
      );
}

