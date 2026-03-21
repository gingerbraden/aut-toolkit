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
class TranslationsCs with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsCs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.cs,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <cs>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsCs _root = this; // ignore: unused_field

	@override 
	TranslationsCs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsCs(meta: meta ?? this.$meta);

	// Translations
	@override String get good_day => 'Dobrý den';
	@override String get sign_in => 'Přihlaste se, abyste mohli používat AutToolkit';
	@override String get sign_in_google => 'Přihlásit se pomocí Google';
	@override String get sign_in_mail => 'Přihlásit se pomocí e-mailu';
	@override String get password => 'Heslo';
	@override String get password_again => 'Potvrďte heslo';
	@override String get no_account => 'Ještě nemáte účet?';
	@override String get create_account => 'Vytvořit účet pomocí e-mailové adresy';
	@override String get log_in_button => 'Přihlásit se';
	@override String get no_sign_in_details => 'Chybějící e-mail nebo heslo';
	@override String get passwords_dont_match => 'Hesla se neshodují';
	@override String get invalid_mail => 'Neplatná e-mailová adresa';
	@override String get invalid_password => 'Heslo musí obsahovat alespoň 6 znaků';
	@override String get invalid_email_password => 'Špatný e-mail nebo heslo';
	@override String get sign_in_button => 'Registrovat se';
	@override String get cancel => 'Zrušit';
	@override String get home => 'Domů';
	@override String get settings => 'Nastavení';
	@override String get kid_mode_button => 'AAC board';
	@override String get signed_in_as => 'Přihlášen jako: ';
	@override String get log_out => 'Odhlásit se';
	@override String get app_language => 'Jazyk aplikace';
	@override String get change => 'Změnit';
	@override String get email => 'E-mail';
	@override String get enter_details => 'Zadejte údaje';
	@override String get really_log_out => 'Opravdu se chcete odhlásit?';
	@override String get yes => 'Ano';
	@override String get no => 'Ne';
	@override String get change_app_language => 'Změnit jazyk aplikace';
	@override String get dark_mode_toggle => 'Tmavý režim';
	@override String get good_habits => 'Zvyky';
	@override String get good_habits_desc => 'Děti s PAS často preferují přísné rutiny a předvídatelnost.';
	@override String get bad_habits => 'Nevhodné chování';
	@override String get eating_habits => 'Stravovací návyky';
	@override String get eating_habits_desc => 'Děti s PAS často jedí vybíravě kvůli senzorické citlivosti.';
	@override String get is_eating => 'Jí';
	@override String get is_not_eating => 'Nejí';
	@override String get active => 'Aktivní';
	@override String get inactive => 'Neaktivní';
	@override String get search => 'Hledat';
	@override String get no_entries => 'Žádné záznamy';
	@override String get from => 'Od';
	@override String get to => 'Do';
	@override String get notes => 'Poznámky';
	@override String get really_delete_object => 'Opravdu chcete smazat ';
	@override String get not_set => 'Nenastaveno';
	@override String get edit => 'Upravit';
	@override String get name => 'Název';
	@override String get please_enter_name => 'Prosím zadejte název';
	@override String get save => 'Uložit';
	@override String get ascending => 'Vzestupně';
	@override String get descending => 'Sestupně';
	@override String get sort_by => 'Seřadit podle';
	@override String get date => 'Datum';
	@override String get filters_and_sorting => 'Filtry a třídění';
	@override String get filters => 'Filtry';
	@override String get sort => 'Třídění podle';
	@override String get challenging_behaviour => 'Nevhodné chování';
	@override String get challenging_behaviour_desc => 'Děti s PAS mohou projevovat náročné chování, když jsou přetížené nebo neumí vyjádřit své potřeby.';
	@override String get occuring => 'Vyskytuje se';
	@override String get not_occuring => 'Nevyskytuje se';
	@override String get location => 'Místo';
	@override String get please_enter_location => 'Prosím zadejte místo';
	@override String get duration => 'Trvání';
	@override String get please_enter_duration => 'Prosím zadejte trvání';
	@override String get invalid_value => 'Neplatná hodnota';
	@override String get one_minute => 'Minuta';
	@override String get few_minutes => 'Minuty';
	@override String get many_minutes => 'Minut';
	@override String get circumstances => 'Okolnosti';
	@override String get people_present => 'Přítomné osoby';
	@override String get outcome => 'Výsledek';
	@override String get reflection => 'Reflexe';
	@override String get add_new_entry => 'Přidat záznam';
	@override String get create => 'Vytvořit';
	@override String get after_typing_enter_submit => 'Po napsání stiskněte "Enter" pro uložení';
	@override String minute({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n,
		one: 'Minuta',
		few: 'Minuty',
		many: 'Minut',
		other: 'Minut',
	);
	@override String get mon => 'Po';
	@override String get tue => 'Út';
	@override String get wed => 'St';
	@override String get thu => 'Čt';
	@override String get fri => 'Pá';
	@override String get sat => 'So';
	@override String get sun => 'Ne';
	@override String get entry => 'Záznam';
	@override String get close => 'Zavřít';
	@override String get managed_people => 'Spravované osoby';
	@override String get add_managed_person => 'Přidat osobu';
	@override String get load_image => 'Nahrát obrázek';
	@override String get change_image => 'Změnit obrázek';
	@override String get delete_image => 'Odstranit obrázek';
	@override String get change_saved => 'Změna uložena';
	@override String get image_changed => 'Obrázek byl změněn';
	@override String get image_deleted => 'Obrázek byl odstraněn';
	@override String get entry_added => 'Záznam přidán';
	@override String get currently_managed_person => 'Právě spravovaná osoba:';
	@override String get crop_image => 'Oříznout obrázek';
	@override String get cards => 'Kartičky';
	@override String get cards_desc => 'Kartičky se používají v AAC klávesnici a při tvorbě vizuálních pomůcek. Nejsou vázány na osobu. Dlouhým podržením kartičky aktivujete mód pro generování kartiček pro tisk.';
	@override String get visual_sequence_boards => 'Vizuální diagramy';
	@override String get visual_sequence_boards_desc => 'Správa vizuálních diagramů';
	@override String get arasaac_icons => 'ARASAAC Ikony';
	@override String get create_card => 'Vytvořit kartičku';
	@override String get create_card_decision => 'Jaký zdroj obrázku chcete použít?';
	@override String get from_gallery => 'Galerie';
	@override String get no_icons_found => 'Nebyla nalezena žádná ikona pro daný výraz.';
	@override String get use_this_image => 'Použít tuto ikonu?';
	@override String get detail => 'Detail';
	@override String get delete => 'Odstranit';
	@override String get cant_undo_action => 'Tuto akci nelze vrátit zpět.';
	@override String get error_occured => 'Došlo k chybě';
	@override String get no_image_set => 'Nebylo nastaveno žádné obrázek';
	@override String get registration_succesful => 'Registrace byla úspěšná. Můžete se přihlásit.';
	@override String get visual_supports => 'Vizuální pomůcky';
	@override String get visual_schedules => 'Vizuální rozvrhy';
	@override String get visual_diagrams => 'Vizuální diagramy';
	@override String get first_then_boards => 'Nejprve-Potom tabulky';
	@override String get visual_diagram_desc => 'Vizuální diagram představuje koncepty, procesy nebo vztahy ve vizuální formě, což pomáhá organizovat informace a pochopit souvislosti.';
	@override String get first_then_boards_desc => 'Tabule „Nejprve–Potom“ pomáhá pochopit a dokončit úkoly tím, že zobrazuje, co je třeba udělat nejdříve a jaká oblíbená činnost následuje.';
	@override String get visual_schedule_desc => 'Vizuální rozvrh zobrazuje pořadí denních aktivit nebo kroků v úkolu a pomáhá pochopit rutiny, snížit úzkost a podporovat samostatnost.';
	@override String get first => 'Nejprve';
	@override String get then => 'Potom';
	@override String steps({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n,
		one: 'Krok',
		few: 'Kroky',
		many: 'Kroků',
		other: 'Kroků',
	);
	@override String get add_step => 'Přidat krok';
	@override String get done => 'Hotovo!';
	@override String get tts_settings => 'Nastavení hlasu';
	@override String get tts_rate => 'Tempo';
	@override String get tts_volume => 'Hlasitost';
	@override String get tts_pitch => 'Tón';
	@override String get tts_test => 'Test hlasu';
	@override String get card_name_language_info => 'Při vytvoření nové kartičky se zadaný název automaticky použije i pro ostatní jazyky. Pokud chcete název upravit v jiném jazyce, změňte jazyk aplikace a poté kartičku znovu upravte. Při úpravě existující kartičky se změna uloží pouze pro aktuálně aktivní jazyk aplikace.';
	@override String get noun => 'Podstatné jméno';
	@override String get pronoun => 'Zájmeno';
	@override String get verb => 'Sloveso';
	@override String get adjective => 'Přídavné jméno';
	@override String get preposition => 'Předložka';
	@override String get question => 'Tázací slovo';
	@override String get negation_important => 'Záporná a důležitá slova';
	@override String get adverb => 'Příslovce';
	@override String get conjunction => 'Spojka';
	@override String get determiner => 'Určovací výraz';
	@override String get please_choose_word_category => 'Prosím vyberte typ slova';
	@override String get word_category => 'Typ slova';
	@override String get data_sync => 'Synchronizuji data, prosím čekejte...';
	@override String get unlocking => 'Odemykám...';
	@override String get locking => 'Klávesnice je zamknutá';
	@override String get hold_to_unlock => 'Držte tlačítko';
	@override String second({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n,
		one: 'sekunda',
		few: 'sekundy',
		many: 'sekund',
		other: 'sekund',
	);
	@override String get to_unlock_hold => 'Pro odemknutí klávesnice podržte tlačítko';
	@override String get grid_settings => 'Nastavení klávesnice';
	@override String get grid_size => 'Rozměry klávesnice';
	@override String get rows => 'Řádky';
	@override String get cols => 'Sloupce';
	@override String get add_card => 'Přidat kartu';
	@override String get add_folder => 'Přidat složku';
	@override String get folder_name => 'Název složky';
	@override String get folder_name_hint => 'např. Jídlo, Tělo, ...';
	@override String get choose_cover_and_save => 'Vybrat ikonu a vytvořit složku';
	@override String get preparing_pdf => 'Připravuji PDF...';
	@override String get or => 'nebo';
	@override String get unknown_error => 'Došlo k neznámé chybě. Prosím zkuste to později.';
	@override String get delete_account => 'Opravdu chcete smazat svůj účet?';
	@override String get delete_account_info => 'Tuto akci nelze vrátit zpět. Všechna vaše data budou smazána!';
	@override String get delete_account_info_password => 'Pro potvrzení smazání účtu zadejte své heslo.';
	@override String get delete_reauthenticate => 'Pro smazání účtu se prosím odhlaste a znovu přihlaste pro reautorizaci.';
	@override String get delete_success => 'Účet byl úspěšně odstraněn.';
	@override String get delete_account_name => 'Odstranit účet';
	@override String get forgot_password => 'Zapomněli jste heslo?';
	@override String get password_reset => 'Resetování hesla';
	@override String get submit => 'Odeslat';
	@override String get really_reset_password => 'Opravdu chcete změnit své heslo?';
	@override String get mail_sent => 'Odkaz pro změnu hesla byl odeslán na váš e-mail.';
	@override String get account_with_email_exists => 'E-mail již byl použit pro registraci. Prosím přihlaste se.';
	@override String get pdf_report_creation => 'Vytvoření PDF reportu';
	@override String get pdf_report_creation_desc => 'Vytvoření dokumentu ke sdílení. Obsahuje záznamy ze stravovacího deníku, nevhodného chování a návyků.';
	@override String get incorrect_password => 'Nesprávné heslo';
	@override String get add_person_info => 'Po vytvoření osoby bude možné evidovat stravovací návyky, nevhodné chování a zvyky. Lze přidat i další osoby – jejich záznamy budou oddělené. Pro přístup k záznamům jiné osoby stačí ji vybrat v tomto menu. Vizuální pomůcky a kartičky nejsou unikátní pro osobu.';
	@override String get from_to_info => 'Od kdy (případně do kdy) je tento záznam aktuální?';
	@override String get is_eating_info => 'Snadno toleruje tuto potravinu, nebo ne?';
	@override String get eating_habit_photo_info => 'Fotografie jídla, potraviny, suroviny.';
	@override String get eating_habit_name => 'Název jídla, potraviny, suroviny...';
	@override String get from_info => 'Od kdy je tento záznam aktuální?';
	@override String get behaviour_occuring_info => 'Vyskytuje se toto chování?';
	@override String get challenging_behaviour_duration_info => 'Jak dlouho toto chování trvalo a kdy nastalo?';
	@override String get challenging_behaviour_people_info => 'Kdo byl přítomen?';
	@override String get visual_schedule_info => 'Pro naplnění vizuálního rozvrhu/diagramu se používají kartičky. Po kliknutí na "Přidat krok" se zobrazí seznam kartiček, kde stačí libovolnou vybrat a bude přidána do rozvrhu. Pro změnu pořadí kroků použijte horizontální ikonu na pravé straně řádku s danou kartičkou.';
	@override String get first_then_board_info => 'Pro naplnění tabulky Nejprve/Potom se používají kartičky. Po kliknutí na "Nejprve" nebo "Potom" se zobrazí seznam kartiček, kde stačí libovolnou vybrat a bude přidána do tabulky.';
	@override String get clear_keyboard_ask => 'Opravdu chcete vyčistit klávesnici?';
	@override String get clear_keyboard_ask_additional => 'Pokud nejste ve složce, budou smazány všechny kartičky a složky. Pokud jste ve složce, budou smazány pouze kartičky a složky v této složce. Toto nelze vrátit zpět.';
	@override String get choose_layout => 'Vyberte rozložení';
	@override String get two_large => '2 karty na řádek (velké)';
	@override String get four_medium => '4 karty na řádek (střední)';
	@override String get six_small => '6 karet na řádek (malé)';
	@override String get visual_supports_desc => 'Vizuální diagramy, rozvrhy a nejprve-pak tabulky. K jejich vytvoření jsou zapotřebí kartičky. Nejsou vázány na osobu.';
	@override String get add_entry_from_QR => 'Přidat záznam pomocí QR kódu';
	@override String get share_entry => 'Sdílet záznam';
	@override String get scan_qr => 'Naskenovat QR kód';
	@override String get incorrect_qr => 'Nesprávný QR kód';
}

/// The flat map containing all translations for locale <cs>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsCs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'good_day' => 'Dobrý den',
			'sign_in' => 'Přihlaste se, abyste mohli používat AutToolkit',
			'sign_in_google' => 'Přihlásit se pomocí Google',
			'sign_in_mail' => 'Přihlásit se pomocí e-mailu',
			'password' => 'Heslo',
			'password_again' => 'Potvrďte heslo',
			'no_account' => 'Ještě nemáte účet?',
			'create_account' => 'Vytvořit účet pomocí e-mailové adresy',
			'log_in_button' => 'Přihlásit se',
			'no_sign_in_details' => 'Chybějící e-mail nebo heslo',
			'passwords_dont_match' => 'Hesla se neshodují',
			'invalid_mail' => 'Neplatná e-mailová adresa',
			'invalid_password' => 'Heslo musí obsahovat alespoň 6 znaků',
			'invalid_email_password' => 'Špatný e-mail nebo heslo',
			'sign_in_button' => 'Registrovat se',
			'cancel' => 'Zrušit',
			'home' => 'Domů',
			'settings' => 'Nastavení',
			'kid_mode_button' => 'AAC board',
			'signed_in_as' => 'Přihlášen jako: ',
			'log_out' => 'Odhlásit se',
			'app_language' => 'Jazyk aplikace',
			'change' => 'Změnit',
			'email' => 'E-mail',
			'enter_details' => 'Zadejte údaje',
			'really_log_out' => 'Opravdu se chcete odhlásit?',
			'yes' => 'Ano',
			'no' => 'Ne',
			'change_app_language' => 'Změnit jazyk aplikace',
			'dark_mode_toggle' => 'Tmavý režim',
			'good_habits' => 'Zvyky',
			'good_habits_desc' => 'Děti s PAS často preferují přísné rutiny a předvídatelnost.',
			'bad_habits' => 'Nevhodné chování',
			'eating_habits' => 'Stravovací návyky',
			'eating_habits_desc' => 'Děti s PAS často jedí vybíravě kvůli senzorické citlivosti.',
			'is_eating' => 'Jí',
			'is_not_eating' => 'Nejí',
			'active' => 'Aktivní',
			'inactive' => 'Neaktivní',
			'search' => 'Hledat',
			'no_entries' => 'Žádné záznamy',
			'from' => 'Od',
			'to' => 'Do',
			'notes' => 'Poznámky',
			'really_delete_object' => 'Opravdu chcete smazat ',
			'not_set' => 'Nenastaveno',
			'edit' => 'Upravit',
			'name' => 'Název',
			'please_enter_name' => 'Prosím zadejte název',
			'save' => 'Uložit',
			'ascending' => 'Vzestupně',
			'descending' => 'Sestupně',
			'sort_by' => 'Seřadit podle',
			'date' => 'Datum',
			'filters_and_sorting' => 'Filtry a třídění',
			'filters' => 'Filtry',
			'sort' => 'Třídění podle',
			'challenging_behaviour' => 'Nevhodné chování',
			'challenging_behaviour_desc' => 'Děti s PAS mohou projevovat náročné chování, když jsou přetížené nebo neumí vyjádřit své potřeby.',
			'occuring' => 'Vyskytuje se',
			'not_occuring' => 'Nevyskytuje se',
			'location' => 'Místo',
			'please_enter_location' => 'Prosím zadejte místo',
			'duration' => 'Trvání',
			'please_enter_duration' => 'Prosím zadejte trvání',
			'invalid_value' => 'Neplatná hodnota',
			'one_minute' => 'Minuta',
			'few_minutes' => 'Minuty',
			'many_minutes' => 'Minut',
			'circumstances' => 'Okolnosti',
			'people_present' => 'Přítomné osoby',
			'outcome' => 'Výsledek',
			'reflection' => 'Reflexe',
			'add_new_entry' => 'Přidat záznam',
			'create' => 'Vytvořit',
			'after_typing_enter_submit' => 'Po napsání stiskněte "Enter" pro uložení',
			'minute' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n, one: 'Minuta', few: 'Minuty', many: 'Minut', other: 'Minut', ), 
			'mon' => 'Po',
			'tue' => 'Út',
			'wed' => 'St',
			'thu' => 'Čt',
			'fri' => 'Pá',
			'sat' => 'So',
			'sun' => 'Ne',
			'entry' => 'Záznam',
			'close' => 'Zavřít',
			'managed_people' => 'Spravované osoby',
			'add_managed_person' => 'Přidat osobu',
			'load_image' => 'Nahrát obrázek',
			'change_image' => 'Změnit obrázek',
			'delete_image' => 'Odstranit obrázek',
			'change_saved' => 'Změna uložena',
			'image_changed' => 'Obrázek byl změněn',
			'image_deleted' => 'Obrázek byl odstraněn',
			'entry_added' => 'Záznam přidán',
			'currently_managed_person' => 'Právě spravovaná osoba:',
			'crop_image' => 'Oříznout obrázek',
			'cards' => 'Kartičky',
			'cards_desc' => 'Kartičky se používají v AAC klávesnici a při tvorbě vizuálních pomůcek. Nejsou vázány na osobu. Dlouhým podržením kartičky aktivujete mód pro generování kartiček pro tisk.',
			'visual_sequence_boards' => 'Vizuální diagramy',
			'visual_sequence_boards_desc' => 'Správa vizuálních diagramů',
			'arasaac_icons' => 'ARASAAC Ikony',
			'create_card' => 'Vytvořit kartičku',
			'create_card_decision' => 'Jaký zdroj obrázku chcete použít?',
			'from_gallery' => 'Galerie',
			'no_icons_found' => 'Nebyla nalezena žádná ikona pro daný výraz.',
			'use_this_image' => 'Použít tuto ikonu?',
			'detail' => 'Detail',
			'delete' => 'Odstranit',
			'cant_undo_action' => 'Tuto akci nelze vrátit zpět.',
			'error_occured' => 'Došlo k chybě',
			'no_image_set' => 'Nebylo nastaveno žádné obrázek',
			'registration_succesful' => 'Registrace byla úspěšná. Můžete se přihlásit.',
			'visual_supports' => 'Vizuální pomůcky',
			'visual_schedules' => 'Vizuální rozvrhy',
			'visual_diagrams' => 'Vizuální diagramy',
			'first_then_boards' => 'Nejprve-Potom tabulky',
			'visual_diagram_desc' => 'Vizuální diagram představuje koncepty, procesy nebo vztahy ve vizuální formě, což pomáhá organizovat informace a pochopit souvislosti.',
			'first_then_boards_desc' => 'Tabule „Nejprve–Potom“ pomáhá pochopit a dokončit úkoly tím, že zobrazuje, co je třeba udělat nejdříve a jaká oblíbená činnost následuje.',
			'visual_schedule_desc' => 'Vizuální rozvrh zobrazuje pořadí denních aktivit nebo kroků v úkolu a pomáhá pochopit rutiny, snížit úzkost a podporovat samostatnost.',
			'first' => 'Nejprve',
			'then' => 'Potom',
			'steps' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n, one: 'Krok', few: 'Kroky', many: 'Kroků', other: 'Kroků', ), 
			'add_step' => 'Přidat krok',
			'done' => 'Hotovo!',
			'tts_settings' => 'Nastavení hlasu',
			'tts_rate' => 'Tempo',
			'tts_volume' => 'Hlasitost',
			'tts_pitch' => 'Tón',
			'tts_test' => 'Test hlasu',
			'card_name_language_info' => 'Při vytvoření nové kartičky se zadaný název automaticky použije i pro ostatní jazyky. Pokud chcete název upravit v jiném jazyce, změňte jazyk aplikace a poté kartičku znovu upravte. Při úpravě existující kartičky se změna uloží pouze pro aktuálně aktivní jazyk aplikace.',
			'noun' => 'Podstatné jméno',
			'pronoun' => 'Zájmeno',
			'verb' => 'Sloveso',
			'adjective' => 'Přídavné jméno',
			'preposition' => 'Předložka',
			'question' => 'Tázací slovo',
			'negation_important' => 'Záporná a důležitá slova',
			'adverb' => 'Příslovce',
			'conjunction' => 'Spojka',
			'determiner' => 'Určovací výraz',
			'please_choose_word_category' => 'Prosím vyberte typ slova',
			'word_category' => 'Typ slova',
			'data_sync' => 'Synchronizuji data, prosím čekejte...',
			'unlocking' => 'Odemykám...',
			'locking' => 'Klávesnice je zamknutá',
			'hold_to_unlock' => 'Držte tlačítko',
			'second' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(n, one: 'sekunda', few: 'sekundy', many: 'sekund', other: 'sekund', ), 
			'to_unlock_hold' => 'Pro odemknutí klávesnice podržte tlačítko',
			'grid_settings' => 'Nastavení klávesnice',
			'grid_size' => 'Rozměry klávesnice',
			'rows' => 'Řádky',
			'cols' => 'Sloupce',
			'add_card' => 'Přidat kartu',
			'add_folder' => 'Přidat složku',
			'folder_name' => 'Název složky',
			'folder_name_hint' => 'např. Jídlo, Tělo, ...',
			'choose_cover_and_save' => 'Vybrat ikonu a vytvořit složku',
			'preparing_pdf' => 'Připravuji PDF...',
			'or' => 'nebo',
			'unknown_error' => 'Došlo k neznámé chybě. Prosím zkuste to později.',
			'delete_account' => 'Opravdu chcete smazat svůj účet?',
			'delete_account_info' => 'Tuto akci nelze vrátit zpět. Všechna vaše data budou smazána!',
			'delete_account_info_password' => 'Pro potvrzení smazání účtu zadejte své heslo.',
			'delete_reauthenticate' => 'Pro smazání účtu se prosím odhlaste a znovu přihlaste pro reautorizaci.',
			'delete_success' => 'Účet byl úspěšně odstraněn.',
			'delete_account_name' => 'Odstranit účet',
			'forgot_password' => 'Zapomněli jste heslo?',
			'password_reset' => 'Resetování hesla',
			'submit' => 'Odeslat',
			'really_reset_password' => 'Opravdu chcete změnit své heslo?',
			'mail_sent' => 'Odkaz pro změnu hesla byl odeslán na váš e-mail.',
			'account_with_email_exists' => 'E-mail již byl použit pro registraci. Prosím přihlaste se.',
			'pdf_report_creation' => 'Vytvoření PDF reportu',
			'pdf_report_creation_desc' => 'Vytvoření dokumentu ke sdílení. Obsahuje záznamy ze stravovacího deníku, nevhodného chování a návyků.',
			'incorrect_password' => 'Nesprávné heslo',
			'add_person_info' => 'Po vytvoření osoby bude možné evidovat stravovací návyky, nevhodné chování a zvyky. Lze přidat i další osoby – jejich záznamy budou oddělené. Pro přístup k záznamům jiné osoby stačí ji vybrat v tomto menu. Vizuální pomůcky a kartičky nejsou unikátní pro osobu.',
			'from_to_info' => 'Od kdy (případně do kdy) je tento záznam aktuální?',
			'is_eating_info' => 'Snadno toleruje tuto potravinu, nebo ne?',
			'eating_habit_photo_info' => 'Fotografie jídla, potraviny, suroviny.',
			'eating_habit_name' => 'Název jídla, potraviny, suroviny...',
			'from_info' => 'Od kdy je tento záznam aktuální?',
			'behaviour_occuring_info' => 'Vyskytuje se toto chování?',
			'challenging_behaviour_duration_info' => 'Jak dlouho toto chování trvalo a kdy nastalo?',
			'challenging_behaviour_people_info' => 'Kdo byl přítomen?',
			'visual_schedule_info' => 'Pro naplnění vizuálního rozvrhu/diagramu se používají kartičky. Po kliknutí na "Přidat krok" se zobrazí seznam kartiček, kde stačí libovolnou vybrat a bude přidána do rozvrhu. Pro změnu pořadí kroků použijte horizontální ikonu na pravé straně řádku s danou kartičkou.',
			'first_then_board_info' => 'Pro naplnění tabulky Nejprve/Potom se používají kartičky. Po kliknutí na "Nejprve" nebo "Potom" se zobrazí seznam kartiček, kde stačí libovolnou vybrat a bude přidána do tabulky.',
			'clear_keyboard_ask' => 'Opravdu chcete vyčistit klávesnici?',
			'clear_keyboard_ask_additional' => 'Pokud nejste ve složce, budou smazány všechny kartičky a složky. Pokud jste ve složce, budou smazány pouze kartičky a složky v této složce. Toto nelze vrátit zpět.',
			'choose_layout' => 'Vyberte rozložení',
			'two_large' => '2 karty na řádek (velké)',
			'four_medium' => '4 karty na řádek (střední)',
			'six_small' => '6 karet na řádek (malé)',
			'visual_supports_desc' => 'Vizuální diagramy, rozvrhy a nejprve-pak tabulky. K jejich vytvoření jsou zapotřebí kartičky. Nejsou vázány na osobu.',
			'add_entry_from_QR' => 'Přidat záznam pomocí QR kódu',
			'share_entry' => 'Sdílet záznam',
			'scan_qr' => 'Naskenovat QR kód',
			'incorrect_qr' => 'Nesprávný QR kód',
			_ => null,
		};
	}
}
