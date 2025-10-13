///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations

  /// en: 'Good day'
  String get good_day => 'Good day';

  /// en: 'Sign in to use AutoToolkit'
  String get sign_in => 'Sign in to use AutoToolkit';

  /// en: 'Sign in with Google'
  String get sign_in_google => 'Sign in with Google';

  /// en: 'Sign in with Email'
  String get sign_in_mail => 'Sign in with Email';

  /// en: 'Continue as Guest'
  String get sign_in_guest => 'Continue as Guest';

  /// en: 'Some features will be unavailable when using the app without signing in'
  String get sign_in_guest_message =>
      'Some features will be unavailable when using the app without signing in';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'good_day':
        return 'Good day';
      case 'sign_in':
        return 'Sign in to use AutoToolkit';
      case 'sign_in_google':
        return 'Sign in with Google';
      case 'sign_in_mail':
        return 'Sign in with Email';
      case 'sign_in_guest':
        return 'Continue as Guest';
      case 'sign_in_guest_message':
        return 'Some features will be unavailable when using the app without signing in';
      default:
        return null;
    }
  }
}
