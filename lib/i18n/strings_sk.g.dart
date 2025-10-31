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
	TranslationsSk({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
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
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsSk _root = this; // ignore: unused_field

	@override 
	TranslationsSk $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsSk(meta: meta ?? this.$meta);

	// Translations
	@override String get good_day => 'Dobrý deň';
	@override String get sign_in => 'Prihláste sa, aby ste mohli používať AutToolkit';
	@override String get sign_in_google => 'Prihlásiť sa pomocou Google';
	@override String get sign_in_mail => 'Prihlásiť sa pomocou e-mailu';
	@override String get password => 'Heslo';
	@override String get password_again => 'Potvrďte heslo';
	@override String get no_account => 'Nemáte ešte účet?';
	@override String get create_account => 'Vytvoriť účet';
	@override String get log_in_button => 'Prihlásiť sa';
	@override String get no_sign_in_details => 'Chýbajuci e-mail alebo heslo';
	@override String get passwords_dont_match => 'Heslá sa nezhodujú';
	@override String get invalid_mail => 'Neplatná e-mailová adresa';
	@override String get invalid_password => 'Heslo musí obsahovať aspoň 6 znakov';
	@override String get invalid_email_password => 'Nesprávny e-mail alebo heslo';
	@override String get sign_in_button => 'Registrovať sa';
	@override String get cancel => 'Zrušiť';
	@override String get home => 'Domov';
	@override String get settings => 'Nastavenia';
	@override String get kid_mode_button => 'Mód aplikácie dieťaťa';
	@override String get signed_in_as => 'Prihlásený ako: ';
	@override String get log_out => 'Odhlásiť sa';
	@override String get app_language => 'Jazyk aplikácie';
	@override String get change => 'Zmeniť';
	@override String get email => 'E-mail';
	@override String get enter_details => 'Zadajte údaje';
	@override String get really_log_out => 'Naozaj sa chcete odhlásiť?';
	@override String get yes => 'Áno';
	@override String get no => 'Nie';
	@override String get change_app_language => 'Zmeniť jazyk aplikácie';
	@override String get dark_mode_toggle => 'Tmavý režim';
	@override String get good_habits => 'Návyky';
	@override String get good_habits_desc => 'Deti s PAS často uprednostňujú prísne rutiny a predvídateľnosť, čo im pomáha cítiť sa bezpečne a pohodlne.';
	@override String get bad_habits => 'Nevhodné správanie';
	@override String get eating_habits => 'Jedálniček';
	@override String get eating_habits_desc => 'Deti s PAS často jedia výberovo kvôli zmyslovej citlivosti. Pokojná rutina a známe jedlá podporujú lepšie stravovacie návyky.';
	@override String get is_eating => 'Je';
	@override String get is_not_eating => 'Neje';
	@override String get active => 'Aktívne';
	@override String get inactive => 'Neaktívne';
	@override String get search => 'Vyhľadať';
	@override String get no_entries => 'Žiadne záznamy';
	@override String get from => 'Od';
	@override String get to => 'Do';
	@override String get notes => 'Poznámky';
	@override String get really_delete_object => 'Naozaj si prajete vymazať ';
	@override String get not_set => 'Nenastavené';
	@override String get edit => 'Upraviť';
	@override String get name => 'Názov';
	@override String get please_enter_name => 'Prosím zadajte názov';
	@override String get save => 'Uložiť';
	@override String get ascending => 'Vzostupne';
	@override String get descending => 'Zostupne';
	@override String get sort_by => 'Zoradiť podľa';
	@override String get date => 'Dátum';
	@override String get filters_and_sorting => 'Filtre a triedenie';
	@override String get filters => 'Filtre';
	@override String get sort => 'Zoradenie podľa';
	@override String get challenging_behaviour => 'Nevhodné správanie';
	@override String get challenging_behaviour_desc => 'Deti s PAS môžu prejavovať náročné správanie, keď sú preťažené alebo nevedia vyjadriť svoje potreby. Pokojné reakcie a jasná rutina znižujú stres a zlepšujú správanie.';
	@override String get occuring => 'Nastáva';
	@override String get not_occuring => 'Nenastáva';
	@override String get location => 'Miesto';
	@override String get please_enter_location => 'Prosím zadajte miesto';
	@override String get duration => 'Trvanie';
	@override String get please_enter_duration => 'Prosím zadajte trvanie';
	@override String get invalid_value => 'Neplatná hodnota';
	@override String get one_minute => 'Minúta';
	@override String get few_minutes => 'Minúty';
	@override String get many_minutes => 'Minút';
	@override String get circumstances => 'Okolnosti';
	@override String get people_present => 'Prítomné osoby';
	@override String get outcome => 'Výsledok';
	@override String get reflection => 'Reflexia';
	@override String get add_new_entry => 'Pridať záznam';
	@override String get create => 'Vytvoriť';
	@override String get after_typing_enter_submit => 'Po napísaní stlačte "Enter" pre uloženie';
	@override String minute({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n,
		one: 'Minúta',
		few: 'Minúty',
		many: 'Minút',
		other: 'Minút',
	);
	@override String get mon => 'Po';
	@override String get tue => 'Ut';
	@override String get wed => 'St';
	@override String get thu => 'Št';
	@override String get fri => 'Pi';
	@override String get sat => 'So';
	@override String get sun => 'Ne';
	@override String get entry => 'Záznam';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsSk {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'good_day': return 'Dobrý deň';
			case 'sign_in': return 'Prihláste sa, aby ste mohli používať AutToolkit';
			case 'sign_in_google': return 'Prihlásiť sa pomocou Google';
			case 'sign_in_mail': return 'Prihlásiť sa pomocou e-mailu';
			case 'password': return 'Heslo';
			case 'password_again': return 'Potvrďte heslo';
			case 'no_account': return 'Nemáte ešte účet?';
			case 'create_account': return 'Vytvoriť účet';
			case 'log_in_button': return 'Prihlásiť sa';
			case 'no_sign_in_details': return 'Chýbajuci e-mail alebo heslo';
			case 'passwords_dont_match': return 'Heslá sa nezhodujú';
			case 'invalid_mail': return 'Neplatná e-mailová adresa';
			case 'invalid_password': return 'Heslo musí obsahovať aspoň 6 znakov';
			case 'invalid_email_password': return 'Nesprávny e-mail alebo heslo';
			case 'sign_in_button': return 'Registrovať sa';
			case 'cancel': return 'Zrušiť';
			case 'home': return 'Domov';
			case 'settings': return 'Nastavenia';
			case 'kid_mode_button': return 'Mód aplikácie dieťaťa';
			case 'signed_in_as': return 'Prihlásený ako: ';
			case 'log_out': return 'Odhlásiť sa';
			case 'app_language': return 'Jazyk aplikácie';
			case 'change': return 'Zmeniť';
			case 'email': return 'E-mail';
			case 'enter_details': return 'Zadajte údaje';
			case 'really_log_out': return 'Naozaj sa chcete odhlásiť?';
			case 'yes': return 'Áno';
			case 'no': return 'Nie';
			case 'change_app_language': return 'Zmeniť jazyk aplikácie';
			case 'dark_mode_toggle': return 'Tmavý režim';
			case 'good_habits': return 'Návyky';
			case 'good_habits_desc': return 'Deti s PAS často uprednostňujú prísne rutiny a predvídateľnosť, čo im pomáha cítiť sa bezpečne a pohodlne.';
			case 'bad_habits': return 'Nevhodné správanie';
			case 'eating_habits': return 'Jedálniček';
			case 'eating_habits_desc': return 'Deti s PAS často jedia výberovo kvôli zmyslovej citlivosti. Pokojná rutina a známe jedlá podporujú lepšie stravovacie návyky.';
			case 'is_eating': return 'Je';
			case 'is_not_eating': return 'Neje';
			case 'active': return 'Aktívne';
			case 'inactive': return 'Neaktívne';
			case 'search': return 'Vyhľadať';
			case 'no_entries': return 'Žiadne záznamy';
			case 'from': return 'Od';
			case 'to': return 'Do';
			case 'notes': return 'Poznámky';
			case 'really_delete_object': return 'Naozaj si prajete vymazať ';
			case 'not_set': return 'Nenastavené';
			case 'edit': return 'Upraviť';
			case 'name': return 'Názov';
			case 'please_enter_name': return 'Prosím zadajte názov';
			case 'save': return 'Uložiť';
			case 'ascending': return 'Vzostupne';
			case 'descending': return 'Zostupne';
			case 'sort_by': return 'Zoradiť podľa';
			case 'date': return 'Dátum';
			case 'filters_and_sorting': return 'Filtre a triedenie';
			case 'filters': return 'Filtre';
			case 'sort': return 'Zoradenie podľa';
			case 'challenging_behaviour': return 'Nevhodné správanie';
			case 'challenging_behaviour_desc': return 'Deti s PAS môžu prejavovať náročné správanie, keď sú preťažené alebo nevedia vyjadriť svoje potreby. Pokojné reakcie a jasná rutina znižujú stres a zlepšujú správanie.';
			case 'occuring': return 'Nastáva';
			case 'not_occuring': return 'Nenastáva';
			case 'location': return 'Miesto';
			case 'please_enter_location': return 'Prosím zadajte miesto';
			case 'duration': return 'Trvanie';
			case 'please_enter_duration': return 'Prosím zadajte trvanie';
			case 'invalid_value': return 'Neplatná hodnota';
			case 'one_minute': return 'Minúta';
			case 'few_minutes': return 'Minúty';
			case 'many_minutes': return 'Minút';
			case 'circumstances': return 'Okolnosti';
			case 'people_present': return 'Prítomné osoby';
			case 'outcome': return 'Výsledok';
			case 'reflection': return 'Reflexia';
			case 'add_new_entry': return 'Pridať záznam';
			case 'create': return 'Vytvoriť';
			case 'after_typing_enter_submit': return 'Po napísaní stlačte "Enter" pre uloženie';
			case 'minute': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n,
				one: 'Minúta',
				few: 'Minúty',
				many: 'Minút',
				other: 'Minút',
			);
			case 'mon': return 'Po';
			case 'tue': return 'Ut';
			case 'wed': return 'St';
			case 'thu': return 'Št';
			case 'fri': return 'Pi';
			case 'sat': return 'So';
			case 'sun': return 'Ne';
			case 'entry': return 'Záznam';
			default: return null;
		}
	}
}

