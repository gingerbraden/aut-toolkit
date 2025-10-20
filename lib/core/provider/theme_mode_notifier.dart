import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void changeTheme(ThemeMode theme) {
    state = theme;
  }
}

final themeModeNotifierProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
      return ThemeModeNotifier();
    });
