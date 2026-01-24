import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driverapp/core/theme/theme_provider.dart';

void main() {
  group('ThemeNotifier', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is ThemeMode.system', () {
      final notifier = ThemeNotifier();
      expect(notifier.state, ThemeMode.system);
    });

    test('setTheme Light changes to ThemeMode.light', () async {
      final notifier = ThemeNotifier();
      await notifier.setTheme('Light');
      expect(notifier.state, ThemeMode.light);
    });

    test('setTheme Dark changes to ThemeMode.dark', () async {
      final notifier = ThemeNotifier();
      await notifier.setTheme('Dark');
      expect(notifier.state, ThemeMode.dark);
    });

    test('setTheme System Default changes to ThemeMode.system', () async {
      final notifier = ThemeNotifier();
      await notifier.setTheme('Dark');
      await notifier.setTheme('System Default');
      expect(notifier.state, ThemeMode.system);
    });

    test('persists theme preference', () async {
      SharedPreferences.setMockInitialValues({'theme': 'Dark'});
      final notifier = ThemeNotifier();
      // Wait for async load
      await Future.delayed(const Duration(milliseconds: 100));
      expect(notifier.state, ThemeMode.dark);
    });
  });
}
