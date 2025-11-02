import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../i18n/strings.g.dart';

class LocaleChangeNotifier extends Notifier<AppLocale> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  AppLocale build() {
    return LocaleSettings.currentLocale;
  }

  void changeLocale(AppLocale locale) {
    LocaleSettings.setLocaleRaw(locale.name);
    state = locale;
    asyncPrefs.setString('locale', locale.name);
  }
}

final localeChangeNotifierProvider =
    NotifierProvider<LocaleChangeNotifier, AppLocale>(() {
      return LocaleChangeNotifier();
    });
