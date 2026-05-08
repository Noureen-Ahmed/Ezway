import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeModeKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeModeKey);
    if (saved == 'dark') state = ThemeMode.dark;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kThemeModeKey, state == ThemeMode.dark ? 'dark' : 'light');
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
