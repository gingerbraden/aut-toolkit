import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  ThemeModeNotifier([ThemeMode? initialTheme])
      : _initialTheme = initialTheme ?? ThemeMode.system;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final ThemeMode _initialTheme;

  @override
  ThemeMode build() => _initialTheme;

  void changeTheme(ThemeMode theme) {
    state = theme;
    asyncPrefs.setString('theme', theme.name);
  }
}

final themeModeNotifierProvider =
NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

