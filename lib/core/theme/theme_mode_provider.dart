import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _themePrefKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light; // Light default per F-06
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themePrefKey);
      if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (_) {
      // Graceful fallback for offline-first local failures
      state = ThemeMode.light;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePrefKey, mode.index);
    } catch (_) {
      // Graceful error logging/handling (offline-first guidelines)
    }
  }

  Future<void> toggleTheme() async {
    final nextMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(nextMode);
  }
}
