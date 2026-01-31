import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  static const _key = 'language';

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const languageNames = {
    'English': 'en',
    'العربية (السعودية)': 'ar',
  };

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      final code = languageNames[saved];
      if (code != null) {
        state = Locale(code);
      }
    }
  }

  Future<void> setLocale(String languageName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageName);
    final code = languageNames[languageName];
    if (code != null) {
      state = Locale(code);
    } else {
      state = null; // system default
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
