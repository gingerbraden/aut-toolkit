///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsSk with BaseTranslations<AppLocale, Translations> implements Translations {
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
	@override String get create_account => 'Vytvoriť účet pomocou e-mailovej adresy';
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
	@override String get kid_mode_button => 'AAC board';
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
	@override String get good_habits_desc => 'Deti s PAS často uprednostňujú prísne rutiny a predvídateľnosť.';
	@override String get bad_habits => 'Nevhodné správanie';
	@override String get eating_habits => 'Jedálniček';
	@override String get eating_habits_desc => 'Deti s PAS často jedia výberovo kvôli zmyslovej citlivosti.';
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
	@override String get challenging_behaviour_desc => 'Deti s PAS môžu prejavovať náročné správanie, keď sú preťažené alebo nevedia vyjadriť svoje potreby.';
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
	@override String get close => 'Zavrieť';
	@override String get managed_people => 'Spravované osoby';
	@override String get add_managed_person => 'Pridať osobu';
	@override String get load_image => 'Nahrať obrázok';
	@override String get change_image => 'Zmeniť obrázok';
	@override String get delete_image => 'Odstrániť obrázok';
	@override String get change_saved => 'Zmena uložená';
	@override String get image_changed => 'Obrázok bol zmenený';
	@override String get image_deleted => 'Obrázok bol odstránený';
	@override String get entry_added => 'Záznam pridaný';
	@override String get currently_managed_person => 'Práve spravovaná osoba:';
	@override String get crop_image => 'Orezať obrázok';
	@override String get cards => 'Kartičky';
	@override String get cards_desc => 'Kartičky sú používané v AAC klávesnici a pri tvorbe vizuálnych pomôcok. Nie sú viazané na osobu. Dlhým podržaním kartičky aktivujete mód na generovanie kartičiek na tlač.';
	@override String get visual_sequence_boards => 'Procesurálne diagramy';
	@override String get visual_sequence_boards_desc => 'Správa procesurálnych diagramov';
	@override String get arasaac_icons => 'ARASAAC Ikony';
	@override String get create_card => 'Vytvoriť kartičku';
	@override String get create_card_decision => 'Aký si želáte použiť zdroj obrázku?';
	@override String get from_gallery => 'Galéria';
	@override String get no_icons_found => 'Neboli nájdené žiadne ikony pre daný vyhľadávací výraz.';
	@override String get use_this_image => 'Použiť túto ikonu?';
	@override String get detail => 'Detail';
	@override String get delete => 'Odstrániť';
	@override String get cant_undo_action => 'Túto akciu nemožno vrátiť späť.';
	@override String get error_occured => 'Nastala chyba';
	@override String get no_image_set => 'Nebol nastavený žiadny obrázok';
	@override String get registration_succesful => 'Registrácia bola úspešná. Môžete sa prihlásiť.';
	@override String get visual_supports => 'Vizuálne pomôcky';
	@override String get visual_schedules => 'Vizuálne rozvrhy';
	@override String get visual_diagrams => 'Vizuálne diagramy';
	@override String get first_then_boards => 'Najprv-Potom tabuľky';
	@override String get visual_diagram_desc => 'Vizuálny diagram predstavuje koncepty, procesy alebo vzťahy vo vizuálnom formáte, čo pomáha organizovať informácie a pochopiť súvislosti.';
	@override String get first_then_boards_desc => 'Tabuľa „Najprv–Potom“ pomáha pochopiť a dokončiť úlohy tým, že zobrazuje, čo treba urobiť najprv a aká obľúbená činnosť nasleduje.';
	@override String get visual_schedule_desc => 'Vizuálny rozvrh zobrazuje poradie denných aktivít alebo krokov v úlohe a pomáha pochopiť rutiny, znížiť úzkosť a podporiť samostatnosť.';
	@override String get first => 'Najprv';
	@override String get then => 'Potom';
	@override String steps({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n,
		one: 'Krok',
		few: 'Kroky',
		many: 'Krokov',
		other: 'Krokov',
	);
	@override String get add_step => 'Pridať krok';
	@override String get done => 'Hotovo!';
	@override String get tts_settings => 'Nastavenia hlasu';
	@override String get tts_rate => 'Tempo';
	@override String get tts_volume => 'Hlasitosť';
	@override String get tts_pitch => 'Tón';
	@override String get tts_test => 'Test hlasu';
	@override String get card_name_language_info => 'Pri vytváraní novej kartičky sa zadaný názov automaticky použije aj pre ostatné jazyky. Ak chcete názov upraviť v inom jazyku, zmeňte jazyk aplikácie a následne kartičku znova upravte. Pri úprave existujúcej kartičky sa zmena sa uloží iba pre práve aktívny jazyk aplikácie.';
	@override String get noun => 'Podstatné meno';
	@override String get pronoun => 'Zámeno';
	@override String get verb => 'Sloveso';
	@override String get adjective => 'Prídavné meno';
	@override String get preposition => 'Predložka';
	@override String get question => 'Opytovacie slovo';
	@override String get negation_important => 'Záporové a dôležité slová';
	@override String get adverb => 'Príslovka';
	@override String get conjunction => 'Spojka';
	@override String get determiner => 'Určovací výraz';
	@override String get please_choose_word_category => 'Prosím zvoľte typ slova';
	@override String get word_category => 'Typ slova';
	@override String get data_sync => 'Synchronizujem dáta, prosim počkajte...';
	@override String get unlocking => 'Odomykám...';
	@override String get locking => 'Klávesnica je zamknutá';
	@override String get hold_to_unlock => 'Držte tlačidlo ešte';
	@override String second({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n,
		one: 'sekunda',
		few: 'sekundy',
		many: 'sekúnd',
		other: 'sekúnd',
	);
	@override String get to_unlock_hold => 'Na odomknutie klávesnice prosím podržte tlačidlo';
	@override String get grid_settings => 'Nastavenia klávesnice';
	@override String get grid_size => 'Rozmery klávesnice';
	@override String get rows => 'Riadky';
	@override String get cols => 'Stĺpce';
	@override String get add_card => 'Pridať kartu';
	@override String get add_folder => 'Pridať priečinok';
	@override String get folder_name => 'Názov priečinka';
	@override String get folder_name_hint => 'napr. Jedlo, Telo, ...';
	@override String get choose_cover_and_save => 'Vybrať ikonu a vytvoriť priečinok';
	@override String get preparing_pdf => 'Pripravujem PDF...';
	@override String get or => 'alebo';
	@override String get unknown_error => 'Nastala neznáma chyba. Prosím opakujte pokus neskôr.';
	@override String get delete_account => 'Naozaj chcete vymazať váš účet?';
	@override String get delete_account_info => 'Túto akciu nie je možné vrátiť späť. Všetky vaše dáta budú vymazané!';
	@override String get delete_account_info_password => 'Pre potvrdenie odstránenia vášho účtu, prosím zadajte svoje heslo.';
	@override String get delete_reauthenticate => 'Pre vymazanie vášho účtu sa prosím odhláste a prihláste, aby ste sa re-autorizovali.';
	@override String get delete_success => 'Účet bol úspešne odstránený.';
	@override String get delete_account_name => 'Odstrániť účet';
	@override String get forgot_password => 'Zabudli ste heslo?';
	@override String get password_reset => 'Resetovanie hesla';
	@override String get submit => 'Odoslať';
	@override String get really_reset_password => 'Naozaj si prajete zmeniť svoje heslo?';
	@override String get mail_sent => 'Odkaz na zmenu hesla bol odoslaný na Váš e-mail.';
	@override String get account_with_email_exists => 'E-mail už bol použitý na registráciu. Prosím prihláste sa.';
	@override String get pdf_report_creation => 'Vygenerovanie PDF reportu';
	@override String get pdf_report_creation_desc => 'Vytvorenie dokumentu na zdieľanie. Obsahuje záznamy z jedálnička, nevhodných správaní a návykov.';
	@override String get incorrect_password => 'Nesprávne heslo';
	@override String get add_person_info => 'Po vytvorení osoby bude možné evidovať jedálniček, nevhodné správanie a návyky. Je možné pridať aj ďalšie osoby - ich záznamy budú oddelené. Pre pristúpenie k záznamom pre inú vytvorenú osobu, stačí ju zvoliť v tomto menu. Vizuálne pomôcky a kartičky nie sú unikátne pre osobu.';
	@override String get from_to_info => 'Odkedy (prípadne dokedy) je tento zápis aktuálny?';
	@override String get is_eating_info => 'Toleruje túto potravinu, alebo nie?';
	@override String get eating_habit_photo_info => 'Fotografia jedla, potraviny, suroviny.';
	@override String get eating_habit_name => 'Názov jedla, potraviny, suroviny...';
	@override String get from_info => 'Odkedy je tento zápis aktuálny?';
	@override String get behaviour_occuring_info => 'Nastáva toto správanie?';
	@override String get challenging_behaviour_duration_info => 'Koľko toto správanie trvalo, a kedy nastalo?';
	@override String get challenging_behaviour_people_info => 'Kto bol prítomný?';
	@override String get visual_schedule_info => 'Pre naplnenie vizuálneho rozvrhu/diagramu sa používajú kartičky. Po kliknutí na "Pridať krok" sa zobrazí zoznam kartičiek, kde stačí ľubovoľnú zvoliť a bude pridaná do rozvrhu. Pre zmenu poradia krokov použite horizontálnu ikonku na pravej strane riadku s danou kartičkou.';
	@override String get first_then_board_info => 'Pre naplnenie najprv/potom tabuľky sa používajú kartičky. Po kliknutí na "Najprv" alebo "Potom" sa zobrazí zoznam kartičiek, kde stačí ľubovoľnú zvoliť a bude pridaná do tabuľky.';
	@override String get clear_keyboard_ask => 'Naozaj si prajete vyčistiť klávesnicu?';
	@override String get clear_keyboard_ask_additional => 'Ak sa nenachádzate v priečinku, vymazané budú všetky kartičky a priečinky. Ak sa nachádzate v priečinku, vymazané budú iba kartičky a priečinky v danom priečinku. Túto akciu nie je možné vrátiť.';
	@override String get choose_layout => 'Vyberte rozloženie';
	@override String get two_large => '2 kartičky na riadok (veľké)';
	@override String get four_medium => '4 kartičky na riadok (stredné)';
	@override String get six_small => '6 kartičiek na riadok (malé)';
	@override String get visual_supports_desc => 'Vizuálne diagramy, rozvrhy a najprv-potom tabuľky. Na ich vytvorenie sú potrebné kartičky. Nie sú viazané na osobu.';
}

/// The flat map containing all translations for locale <sk>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsSk {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'good_day' => 'Dobrý deň',
			'sign_in' => 'Prihláste sa, aby ste mohli používať AutToolkit',
			'sign_in_google' => 'Prihlásiť sa pomocou Google',
			'sign_in_mail' => 'Prihlásiť sa pomocou e-mailu',
			'password' => 'Heslo',
			'password_again' => 'Potvrďte heslo',
			'no_account' => 'Nemáte ešte účet?',
			'create_account' => 'Vytvoriť účet pomocou e-mailovej adresy',
			'log_in_button' => 'Prihlásiť sa',
			'no_sign_in_details' => 'Chýbajuci e-mail alebo heslo',
			'passwords_dont_match' => 'Heslá sa nezhodujú',
			'invalid_mail' => 'Neplatná e-mailová adresa',
			'invalid_password' => 'Heslo musí obsahovať aspoň 6 znakov',
			'invalid_email_password' => 'Nesprávny e-mail alebo heslo',
			'sign_in_button' => 'Registrovať sa',
			'cancel' => 'Zrušiť',
			'home' => 'Domov',
			'settings' => 'Nastavenia',
			'kid_mode_button' => 'AAC board',
			'signed_in_as' => 'Prihlásený ako: ',
			'log_out' => 'Odhlásiť sa',
			'app_language' => 'Jazyk aplikácie',
			'change' => 'Zmeniť',
			'email' => 'E-mail',
			'enter_details' => 'Zadajte údaje',
			'really_log_out' => 'Naozaj sa chcete odhlásiť?',
			'yes' => 'Áno',
			'no' => 'Nie',
			'change_app_language' => 'Zmeniť jazyk aplikácie',
			'dark_mode_toggle' => 'Tmavý režim',
			'good_habits' => 'Návyky',
			'good_habits_desc' => 'Deti s PAS často uprednostňujú prísne rutiny a predvídateľnosť.',
			'bad_habits' => 'Nevhodné správanie',
			'eating_habits' => 'Jedálniček',
			'eating_habits_desc' => 'Deti s PAS často jedia výberovo kvôli zmyslovej citlivosti.',
			'is_eating' => 'Je',
			'is_not_eating' => 'Neje',
			'active' => 'Aktívne',
			'inactive' => 'Neaktívne',
			'search' => 'Vyhľadať',
			'no_entries' => 'Žiadne záznamy',
			'from' => 'Od',
			'to' => 'Do',
			'notes' => 'Poznámky',
			'really_delete_object' => 'Naozaj si prajete vymazať ',
			'not_set' => 'Nenastavené',
			'edit' => 'Upraviť',
			'name' => 'Názov',
			'please_enter_name' => 'Prosím zadajte názov',
			'save' => 'Uložiť',
			'ascending' => 'Vzostupne',
			'descending' => 'Zostupne',
			'sort_by' => 'Zoradiť podľa',
			'date' => 'Dátum',
			'filters_and_sorting' => 'Filtre a triedenie',
			'filters' => 'Filtre',
			'sort' => 'Zoradenie podľa',
			'challenging_behaviour' => 'Nevhodné správanie',
			'challenging_behaviour_desc' => 'Deti s PAS môžu prejavovať náročné správanie, keď sú preťažené alebo nevedia vyjadriť svoje potreby.',
			'occuring' => 'Nastáva',
			'not_occuring' => 'Nenastáva',
			'location' => 'Miesto',
			'please_enter_location' => 'Prosím zadajte miesto',
			'duration' => 'Trvanie',
			'please_enter_duration' => 'Prosím zadajte trvanie',
			'invalid_value' => 'Neplatná hodnota',
			'one_minute' => 'Minúta',
			'few_minutes' => 'Minúty',
			'many_minutes' => 'Minút',
			'circumstances' => 'Okolnosti',
			'people_present' => 'Prítomné osoby',
			'outcome' => 'Výsledok',
			'reflection' => 'Reflexia',
			'add_new_entry' => 'Pridať záznam',
			'create' => 'Vytvoriť',
			'after_typing_enter_submit' => 'Po napísaní stlačte "Enter" pre uloženie',
			'minute' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n, one: 'Minúta', few: 'Minúty', many: 'Minút', other: 'Minút', ), 
			'mon' => 'Po',
			'tue' => 'Ut',
			'wed' => 'St',
			'thu' => 'Št',
			'fri' => 'Pi',
			'sat' => 'So',
			'sun' => 'Ne',
			'entry' => 'Záznam',
			'close' => 'Zavrieť',
			'managed_people' => 'Spravované osoby',
			'add_managed_person' => 'Pridať osobu',
			'load_image' => 'Nahrať obrázok',
			'change_image' => 'Zmeniť obrázok',
			'delete_image' => 'Odstrániť obrázok',
			'change_saved' => 'Zmena uložená',
			'image_changed' => 'Obrázok bol zmenený',
			'image_deleted' => 'Obrázok bol odstránený',
			'entry_added' => 'Záznam pridaný',
			'currently_managed_person' => 'Práve spravovaná osoba:',
			'crop_image' => 'Orezať obrázok',
			'cards' => 'Kartičky',
			'cards_desc' => 'Kartičky sú používané v AAC klávesnici a pri tvorbe vizuálnych pomôcok. Nie sú viazané na osobu. Dlhým podržaním kartičky aktivujete mód na generovanie kartičiek na tlač.',
			'visual_sequence_boards' => 'Procesurálne diagramy',
			'visual_sequence_boards_desc' => 'Správa procesurálnych diagramov',
			'arasaac_icons' => 'ARASAAC Ikony',
			'create_card' => 'Vytvoriť kartičku',
			'create_card_decision' => 'Aký si želáte použiť zdroj obrázku?',
			'from_gallery' => 'Galéria',
			'no_icons_found' => 'Neboli nájdené žiadne ikony pre daný vyhľadávací výraz.',
			'use_this_image' => 'Použiť túto ikonu?',
			'detail' => 'Detail',
			'delete' => 'Odstrániť',
			'cant_undo_action' => 'Túto akciu nemožno vrátiť späť.',
			'error_occured' => 'Nastala chyba',
			'no_image_set' => 'Nebol nastavený žiadny obrázok',
			'registration_succesful' => 'Registrácia bola úspešná. Môžete sa prihlásiť.',
			'visual_supports' => 'Vizuálne pomôcky',
			'visual_schedules' => 'Vizuálne rozvrhy',
			'visual_diagrams' => 'Vizuálne diagramy',
			'first_then_boards' => 'Najprv-Potom tabuľky',
			'visual_diagram_desc' => 'Vizuálny diagram predstavuje koncepty, procesy alebo vzťahy vo vizuálnom formáte, čo pomáha organizovať informácie a pochopiť súvislosti.',
			'first_then_boards_desc' => 'Tabuľa „Najprv–Potom“ pomáha pochopiť a dokončiť úlohy tým, že zobrazuje, čo treba urobiť najprv a aká obľúbená činnosť nasleduje.',
			'visual_schedule_desc' => 'Vizuálny rozvrh zobrazuje poradie denných aktivít alebo krokov v úlohe a pomáha pochopiť rutiny, znížiť úzkosť a podporiť samostatnosť.',
			'first' => 'Najprv',
			'then' => 'Potom',
			'steps' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n, one: 'Krok', few: 'Kroky', many: 'Krokov', other: 'Krokov', ), 
			'add_step' => 'Pridať krok',
			'done' => 'Hotovo!',
			'tts_settings' => 'Nastavenia hlasu',
			'tts_rate' => 'Tempo',
			'tts_volume' => 'Hlasitosť',
			'tts_pitch' => 'Tón',
			'tts_test' => 'Test hlasu',
			'card_name_language_info' => 'Pri vytváraní novej kartičky sa zadaný názov automaticky použije aj pre ostatné jazyky. Ak chcete názov upraviť v inom jazyku, zmeňte jazyk aplikácie a následne kartičku znova upravte. Pri úprave existujúcej kartičky sa zmena sa uloží iba pre práve aktívny jazyk aplikácie.',
			'noun' => 'Podstatné meno',
			'pronoun' => 'Zámeno',
			'verb' => 'Sloveso',
			'adjective' => 'Prídavné meno',
			'preposition' => 'Predložka',
			'question' => 'Opytovacie slovo',
			'negation_important' => 'Záporové a dôležité slová',
			'adverb' => 'Príslovka',
			'conjunction' => 'Spojka',
			'determiner' => 'Určovací výraz',
			'please_choose_word_category' => 'Prosím zvoľte typ slova',
			'word_category' => 'Typ slova',
			'data_sync' => 'Synchronizujem dáta, prosim počkajte...',
			'unlocking' => 'Odomykám...',
			'locking' => 'Klávesnica je zamknutá',
			'hold_to_unlock' => 'Držte tlačidlo ešte',
			'second' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('sk'))(n, one: 'sekunda', few: 'sekundy', many: 'sekúnd', other: 'sekúnd', ), 
			'to_unlock_hold' => 'Na odomknutie klávesnice prosím podržte tlačidlo',
			'grid_settings' => 'Nastavenia klávesnice',
			'grid_size' => 'Rozmery klávesnice',
			'rows' => 'Riadky',
			'cols' => 'Stĺpce',
			'add_card' => 'Pridať kartu',
			'add_folder' => 'Pridať priečinok',
			'folder_name' => 'Názov priečinka',
			'folder_name_hint' => 'napr. Jedlo, Telo, ...',
			'choose_cover_and_save' => 'Vybrať ikonu a vytvoriť priečinok',
			'preparing_pdf' => 'Pripravujem PDF...',
			'or' => 'alebo',
			'unknown_error' => 'Nastala neznáma chyba. Prosím opakujte pokus neskôr.',
			'delete_account' => 'Naozaj chcete vymazať váš účet?',
			'delete_account_info' => 'Túto akciu nie je možné vrátiť späť. Všetky vaše dáta budú vymazané!',
			'delete_account_info_password' => 'Pre potvrdenie odstránenia vášho účtu, prosím zadajte svoje heslo.',
			'delete_reauthenticate' => 'Pre vymazanie vášho účtu sa prosím odhláste a prihláste, aby ste sa re-autorizovali.',
			'delete_success' => 'Účet bol úspešne odstránený.',
			'delete_account_name' => 'Odstrániť účet',
			'forgot_password' => 'Zabudli ste heslo?',
			'password_reset' => 'Resetovanie hesla',
			'submit' => 'Odoslať',
			'really_reset_password' => 'Naozaj si prajete zmeniť svoje heslo?',
			'mail_sent' => 'Odkaz na zmenu hesla bol odoslaný na Váš e-mail.',
			'account_with_email_exists' => 'E-mail už bol použitý na registráciu. Prosím prihláste sa.',
			'pdf_report_creation' => 'Vygenerovanie PDF reportu',
			'pdf_report_creation_desc' => 'Vytvorenie dokumentu na zdieľanie. Obsahuje záznamy z jedálnička, nevhodných správaní a návykov.',
			'incorrect_password' => 'Nesprávne heslo',
			'add_person_info' => 'Po vytvorení osoby bude možné evidovať jedálniček, nevhodné správanie a návyky. Je možné pridať aj ďalšie osoby - ich záznamy budú oddelené. Pre pristúpenie k záznamom pre inú vytvorenú osobu, stačí ju zvoliť v tomto menu. Vizuálne pomôcky a kartičky nie sú unikátne pre osobu.',
			'from_to_info' => 'Odkedy (prípadne dokedy) je tento zápis aktuálny?',
			'is_eating_info' => 'Toleruje túto potravinu, alebo nie?',
			'eating_habit_photo_info' => 'Fotografia jedla, potraviny, suroviny.',
			'eating_habit_name' => 'Názov jedla, potraviny, suroviny...',
			'from_info' => 'Odkedy je tento zápis aktuálny?',
			'behaviour_occuring_info' => 'Nastáva toto správanie?',
			'challenging_behaviour_duration_info' => 'Koľko toto správanie trvalo, a kedy nastalo?',
			'challenging_behaviour_people_info' => 'Kto bol prítomný?',
			'visual_schedule_info' => 'Pre naplnenie vizuálneho rozvrhu/diagramu sa používajú kartičky. Po kliknutí na "Pridať krok" sa zobrazí zoznam kartičiek, kde stačí ľubovoľnú zvoliť a bude pridaná do rozvrhu. Pre zmenu poradia krokov použite horizontálnu ikonku na pravej strane riadku s danou kartičkou.',
			'first_then_board_info' => 'Pre naplnenie najprv/potom tabuľky sa používajú kartičky. Po kliknutí na "Najprv" alebo "Potom" sa zobrazí zoznam kartičiek, kde stačí ľubovoľnú zvoliť a bude pridaná do tabuľky.',
			'clear_keyboard_ask' => 'Naozaj si prajete vyčistiť klávesnicu?',
			'clear_keyboard_ask_additional' => 'Ak sa nenachádzate v priečinku, vymazané budú všetky kartičky a priečinky. Ak sa nachádzate v priečinku, vymazané budú iba kartičky a priečinky v danom priečinku. Túto akciu nie je možné vrátiť.',
			'choose_layout' => 'Vyberte rozloženie',
			'two_large' => '2 kartičky na riadok (veľké)',
			'four_medium' => '4 kartičky na riadok (stredné)',
			'six_small' => '6 kartičiek na riadok (malé)',
			'visual_supports_desc' => 'Vizuálne diagramy, rozvrhy a najprv-potom tabuľky. Na ich vytvorenie sú potrebné kartičky. Nie sú viazané na osobu.',
			_ => null,
		};
	}
}
