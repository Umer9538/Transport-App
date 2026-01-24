import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driverapp/core/localization/locale_provider.dart';

void main() {
  group('LocaleNotifier', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is null (system default)', () {
      final notifier = LocaleNotifier();
      expect(notifier.state, isNull);
    });

    test('setLocale English sets en locale', () async {
      final notifier = LocaleNotifier();
      await notifier.setLocale('English (US)');
      expect(notifier.state, const Locale('en'));
    });

    test('setLocale Arabic sets ar locale', () async {
      final notifier = LocaleNotifier();
      await notifier.setLocale('\u0627\u0644\u0639\u0631\u0628\u064A\u0629');
      expect(notifier.state, const Locale('ar'));
    });

    test('supportedLocales contains en and ar', () {
      expect(LocaleNotifier.supportedLocales, contains(const Locale('en')));
      expect(LocaleNotifier.supportedLocales, contains(const Locale('ar')));
    });

    test('persists locale preference', () async {
      SharedPreferences.setMockInitialValues({'language': '\u0627\u0644\u0639\u0631\u0628\u064A\u0629'});
      final notifier = LocaleNotifier();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(notifier.state, const Locale('ar'));
    });
  });
}
