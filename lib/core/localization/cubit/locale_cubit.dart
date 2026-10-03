import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user's language choice (en / de / ar) and persists it.
class LocaleCubit extends Cubit<Locale> {
  /// Creates the cubit, restoring the saved choice (defaults to English).
  LocaleCubit(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static const _key = 'language_code';

  static Locale _read(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved != null) return Locale(saved);
    return const Locale('en'); // Default to English as per Phase 1
  }

  /// Changes and saves the language.
  Future<void> setLocale(String languageCode) async {
    emit(Locale(languageCode));
    await _prefs.setString(_key, languageCode);
  }
}
