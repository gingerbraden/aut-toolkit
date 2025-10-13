///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'strings.g.dart';

// Path: <root>
class TranslationsSk implements Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsSk({Map<String,
      Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<
      AppLocale,
      Translations>? meta})
      : assert(overrides ==
      null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ?? TranslationMetadata(
          locale: AppLocale.sk,
          overrides: overrides ?? {},
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <sk>.
  @override final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override dynamic operator [](String key) => $meta.getTranslation(key);

  late final TranslationsSk _root = this; // ignore: unused_field

  @override
  TranslationsSk $copyWith(
      {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsSk(meta: meta ?? this.$meta);

  // Translations
  @override String get good_day => 'Dobrý deň';

  @override String get sign_in =>
      'Prihláste sa, aby ste mohli používať AutToolkit';

  @override String get sign_in_google => 'Prihlásiť sa pomocou Google';

  @override String get sign_in_mail => 'Prihlásiť sa pomocou e-mailu';

  @override String get sign_in_guest => 'Pokračovať bez prihlásenia';

  @override String get sign_in_guest_message =>
      'Pri používaní aplikácie bez prihlásenia budú niektoré funkcionality zablokované';

  @override String get password => 'Heslo';

  @override String get password_again => 'Potvrďte heslo';

  @override String get no_account => 'Nemáte ešte účet?';

  @override String get create_account => 'Vytvoriť účet';

  @override String get log_in_button => 'Prihlásiť sa';

  @override String get no_sign_in_details => 'Chýbajuci e-mail alebo heslo';

  @override String get passwords_dont_match => 'Heslá sa nezhodujú';

  @override String get invalid_mail => 'Neplatná e-mailová adresa';

  @override String get invalid_password =>
      'Heslo musí obsahovať aspoň 6 znakov';

  @override String get invalid_email_password => 'Nesprávny e-mail alebo heslo';

  @override String get sign_in_button => 'Registrovať sa';

  @override String get cancel => 'Zrušiť';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsSk {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'good_day':
        return 'Dobrý deň';
      case 'sign_in':
        return 'Prihláste sa, aby ste mohli používať AutToolkit';
      case 'sign_in_google':
        return 'Prihlásiť sa pomocou Google';
      case 'sign_in_mail':
        return 'Prihlásiť sa pomocou e-mailu';
      case 'sign_in_guest':
        return 'Pokračovať bez prihlásenia';
      case 'sign_in_guest_message':
        return 'Pri používaní aplikácie bez prihlásenia budú niektoré funkcionality zablokované';
      case 'password':
        return 'Heslo';
      case 'password_again':
        return 'Potvrďte heslo';
      case 'no_account':
        return 'Nemáte ešte účet?';
      case 'create_account':
        return 'Vytvoriť účet';
      case 'log_in_button':
        return 'Prihlásiť sa';
      case 'no_sign_in_details':
        return 'Chýbajuci e-mail alebo heslo';
      case 'passwords_dont_match':
        return 'Heslá sa nezhodujú';
      case 'invalid_mail':
        return 'Neplatná e-mailová adresa';
      case 'invalid_password':
        return 'Heslo musí obsahovať aspoň 6 znakov';
      case 'invalid_email_password':
        return 'Nesprávny e-mail alebo heslo';
      case 'sign_in_button':
        return 'Registrovať sa';
      case 'cancel':
        return 'Zrušiť';
      default:
        return null;
    }
  }
}

