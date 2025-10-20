import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';

class LocaleChangeNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    return LocaleSettings.currentLocale;
  }

  void changeLocale(AppLocale locale) {
    LocaleSettings.setLocaleRaw(locale.name);
    state = locale;
  }
}

final localeChangeNotifierProvider =
    NotifierProvider<LocaleChangeNotifier, AppLocale>(() {
      return LocaleChangeNotifier();
    });
