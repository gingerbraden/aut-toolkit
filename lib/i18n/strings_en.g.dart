///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Hello!'
	String get good_day => 'Hello!';

	/// en: 'Please sign in to use AutToolkit'
	String get sign_in => 'Please sign in to use AutToolkit';

	/// en: 'Sign in with Google'
	String get sign_in_google => 'Sign in with Google';

	/// en: 'Sign in with Email'
	String get sign_in_mail => 'Sign in with Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm password'
	String get password_again => 'Confirm password';

	/// en: 'No account yet?'
	String get no_account => 'No account yet?';

	/// en: 'Create account using an e-mail address'
	String get create_account => 'Create account using an e-mail address';

	/// en: 'Log in'
	String get log_in_button => 'Log in';

	/// en: 'Missing e-mail or password'
	String get no_sign_in_details => 'Missing e-mail or password';

	/// en: 'Passwords don't match'
	String get passwords_dont_match => 'Passwords don\'t match';

	/// en: 'Invalid e-mail address'
	String get invalid_mail => 'Invalid e-mail address';

	/// en: 'Password must contain at elast 6 characters'
	String get invalid_password => 'Password must contain at elast 6 characters';

	/// en: 'Incorrect e-mail or password'
	String get invalid_email_password => 'Incorrect e-mail or password';

	/// en: 'Sign in'
	String get sign_in_button => 'Sign in';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Child app mode'
	String get kid_mode_button => 'Child app mode';

	/// en: 'Signed in as: '
	String get signed_in_as => 'Signed in as: ';

	/// en: 'Log out'
	String get log_out => 'Log out';

	/// en: 'App language'
	String get app_language => 'App language';

	/// en: 'Change'
	String get change => 'Change';

	/// en: 'E-mail'
	String get email => 'E-mail';

	/// en: 'Enter details'
	String get enter_details => 'Enter details';

	/// en: 'Do you really want to log out?'
	String get really_log_out => 'Do you really want to log out?';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'No'
	String get no => 'No';

	/// en: 'Change app language'
	String get change_app_language => 'Change app language';

	/// en: 'Dark mode'
	String get dark_mode_toggle => 'Dark mode';

	/// en: 'Habits'
	String get good_habits => 'Habits';

	/// en: 'Autistic children often prefer strict routines and predictability.'
	String get good_habits_desc => 'Autistic children often prefer strict routines and predictability.';

	/// en: 'Bad habits'
	String get bad_habits => 'Bad habits';

	/// en: 'Eating habits'
	String get eating_habits => 'Eating habits';

	/// en: 'Autistic children often eat selectively due to sensory sensitivities.'
	String get eating_habits_desc => 'Autistic children often eat selectively due to sensory sensitivities.';

	/// en: 'Eats'
	String get is_eating => 'Eats';

	/// en: 'Does not eat'
	String get is_not_eating => 'Does not eat';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'No entries'
	String get no_entries => 'No entries';

	/// en: 'From'
	String get from => 'From';

	/// en: 'To'
	String get to => 'To';

	/// en: 'Notes'
	String get notes => 'Notes';

	/// en: 'Do you really wish to delete '
	String get really_delete_object => 'Do you really wish to delete ';

	/// en: 'Not set'
	String get not_set => 'Not set';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Please enter a name'
	String get please_enter_name => 'Please enter a name';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Ascending'
	String get ascending => 'Ascending';

	/// en: 'Descending'
	String get descending => 'Descending';

	/// en: 'Sort by'
	String get sort_by => 'Sort by';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Filters and sorting'
	String get filters_and_sorting => 'Filters and sorting';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Sort by'
	String get sort => 'Sort by';

	/// en: 'Challenging behaviour'
	String get challenging_behaviour => 'Challenging behaviour';

	/// en: 'Autistic children may show challenging behavior when overwhelmed or unable to communicate needs.'
	String get challenging_behaviour_desc => 'Autistic children may show challenging behavior when overwhelmed or unable to communicate needs.';

	/// en: 'Occuring'
	String get occuring => 'Occuring';

	/// en: 'Not occuring'
	String get not_occuring => 'Not occuring';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Please enter a location'
	String get please_enter_location => 'Please enter a location';

	/// en: 'Duration'
	String get duration => 'Duration';

	/// en: 'Please enter duration'
	String get please_enter_duration => 'Please enter duration';

	/// en: 'Invalid value'
	String get invalid_value => 'Invalid value';

	/// en: 'Minute'
	String get one_minute => 'Minute';

	/// en: 'Minutes'
	String get few_minutes => 'Minutes';

	/// en: 'Minutes'
	String get many_minutes => 'Minutes';

	/// en: 'Circumstances'
	String get circumstances => 'Circumstances';

	/// en: 'People present'
	String get people_present => 'People present';

	/// en: 'Outcome'
	String get outcome => 'Outcome';

	/// en: 'Reflection'
	String get reflection => 'Reflection';

	/// en: 'Add new entry'
	String get add_new_entry => 'Add new entry';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'After typing press "Enter" to save'
	String get after_typing_enter_submit => 'After typing press "Enter" to save';

	/// en: '(zero) {Minutes} (one) {Minute} (other) {Minutes}'
	String minute({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'Minutes',
		one: 'Minute',
		other: 'Minutes',
	);

	/// en: 'Mon'
	String get mon => 'Mon';

	/// en: 'Tue'
	String get tue => 'Tue';

	/// en: 'Wed'
	String get wed => 'Wed';

	/// en: 'Thu'
	String get thu => 'Thu';

	/// en: 'Fri'
	String get fri => 'Fri';

	/// en: 'Sat'
	String get sat => 'Sat';

	/// en: 'Sun'
	String get sun => 'Sun';

	/// en: 'Entry'
	String get entry => 'Entry';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Managed people'
	String get managed_people => 'Managed people';

	/// en: 'Add a person'
	String get add_managed_person => 'Add a person';

	/// en: 'Add image'
	String get load_image => 'Add image';

	/// en: 'Change image'
	String get change_image => 'Change image';

	/// en: 'Delete image'
	String get delete_image => 'Delete image';

	/// en: 'Change saved'
	String get change_saved => 'Change saved';

	/// en: 'Image was changed'
	String get image_changed => 'Image was changed';

	/// en: 'Image was deleted'
	String get image_deleted => 'Image was deleted';

	/// en: 'Entry added'
	String get entry_added => 'Entry added';

	/// en: 'Currently managed person:'
	String get currently_managed_person => 'Currently managed person:';

	/// en: 'Crop image'
	String get crop_image => 'Crop image';

	/// en: 'Cards'
	String get cards => 'Cards';

	/// en: 'Cards are used in the AAC board and visual supports. They are not tied to a person. By long-pressing the card, you activate the mode for generating printable cards.'
	String get cards_desc => 'Cards are used in the AAC board and visual supports. They are not tied to a person. By long-pressing the card, you activate the mode for generating printable cards.';

	/// en: 'Visual sequence boards'
	String get visual_sequence_boards => 'Visual sequence boards';

	/// en: 'Visual sequence boards management'
	String get visual_sequence_boards_desc => 'Visual sequence boards management';

	/// en: 'ARASAAC Icons'
	String get arasaac_icons => 'ARASAAC Icons';

	/// en: 'Create cards'
	String get create_card => 'Create cards';

	/// en: 'What source would like to use for the icon?'
	String get create_card_decision => 'What source would like to use for the icon?';

	/// en: 'Gallery'
	String get from_gallery => 'Gallery';

	/// en: 'No icons found for given search query.'
	String get no_icons_found => 'No icons found for given search query.';

	/// en: 'Use this icon?'
	String get use_this_image => 'Use this icon?';

	/// en: 'Detail'
	String get detail => 'Detail';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'This action cannot be undone.'
	String get cant_undo_action => 'This action cannot be undone.';

	/// en: 'An error occured'
	String get error_occured => 'An error occured';

	/// en: 'No image was set.'
	String get no_image_set => 'No image was set.';

	/// en: 'Registration was succesful. You can now log in.'
	String get registration_succesful => 'Registration was succesful. You can now log in.';

	/// en: 'Visual supports'
	String get visual_supports => 'Visual supports';

	/// en: 'Visual schedules'
	String get visual_schedules => 'Visual schedules';

	/// en: 'Vizuálne diagramy'
	String get visual_diagrams => 'Vizuálne diagramy';

	/// en: 'First–Then boards'
	String get first_then_boards => 'First–Then boards';

	/// en: 'A Visual Diagram represents concepts, processes, or relationships in a visual format, helping to organize information and understand connections.'
	String get visual_diagram_desc => 'A Visual Diagram represents concepts, processes, or relationships in a visual format, helping to organize information and understand connections.';

	/// en: 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.'
	String get first_then_boards_desc => 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.';

	/// en: 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.'
	String get visual_schedule_desc => 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.';

	/// en: 'First'
	String get first => 'First';

	/// en: 'Then'
	String get then => 'Then';

	/// en: '(one) {Step} (few) {Steps} (many) {Steps} (other) {Steps}'
	String steps({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Step',
		few: 'Steps',
		many: 'Steps',
		other: 'Steps',
	);

	/// en: 'Add step'
	String get add_step => 'Add step';

	/// en: 'Done!'
	String get done => 'Done!';

	/// en: 'Voice settings'
	String get tts_settings => 'Voice settings';

	/// en: 'Rate'
	String get tts_rate => 'Rate';

	/// en: 'Volume'
	String get tts_volume => 'Volume';

	/// en: 'Pitch'
	String get tts_pitch => 'Pitch';

	/// en: 'Voice test'
	String get tts_test => 'Voice test';

	/// en: 'When creating a new card, the entered name is automatically used for all languages. To change the name in another language, switch the app language and then edit the card again. When editing an existing card, the change will be saved only for the currently active app language.'
	String get card_name_language_info => 'When creating a new card, the entered name is automatically used for all languages. To change the name in another language, switch the app language and then edit the card again. When editing an existing card, the change will be saved only for the currently active app language.';

	/// en: 'Noun'
	String get noun => 'Noun';

	/// en: 'Pronoun'
	String get pronoun => 'Pronoun';

	/// en: 'Verb'
	String get verb => 'Verb';

	/// en: 'Adjective'
	String get adjective => 'Adjective';

	/// en: 'Preposition'
	String get preposition => 'Preposition';

	/// en: 'Question word'
	String get question => 'Question word';

	/// en: 'Negation & important words'
	String get negation_important => 'Negation & important words';

	/// en: 'Adverb'
	String get adverb => 'Adverb';

	/// en: 'Conjunction'
	String get conjunction => 'Conjunction';

	/// en: 'Determiner'
	String get determiner => 'Determiner';

	/// en: 'Please choose a word type'
	String get please_choose_word_category => 'Please choose a word type';

	/// en: 'Word type'
	String get word_category => 'Word type';

	/// en: 'Syncing data, please wait...'
	String get data_sync => 'Syncing data, please wait...';

	/// en: 'Unlocking...'
	String get unlocking => 'Unlocking...';

	/// en: 'Keyboard is locked'
	String get locking => 'Keyboard is locked';

	/// en: 'Keep holding the button for'
	String get hold_to_unlock => 'Keep holding the button for';

	/// en: '(one) {second} (few) {seconds} (many) {Seconds} (other) {seconds}'
	String second({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'second',
		few: 'seconds',
		many: 'Seconds',
		other: 'seconds',
	);

	/// en: 'To unlock the keyboard please hold the button for'
	String get to_unlock_hold => 'To unlock the keyboard please hold the button for';

	/// en: 'Keyboard settings'
	String get grid_settings => 'Keyboard settings';

	/// en: 'Keyboard size'
	String get grid_size => 'Keyboard size';

	/// en: 'Rows'
	String get rows => 'Rows';

	/// en: 'Columns'
	String get cols => 'Columns';

	/// en: 'Add a card'
	String get add_card => 'Add a card';

	/// en: 'Add a folder'
	String get add_folder => 'Add a folder';

	/// en: 'Folder name'
	String get folder_name => 'Folder name';

	/// en: 'e. g. Food, Body, ...'
	String get folder_name_hint => 'e. g. Food, Body, ...';

	/// en: 'Choose icon and create folder'
	String get choose_cover_and_save => 'Choose icon and create folder';

	/// en: 'Preparing PDF...'
	String get preparing_pdf => 'Preparing PDF...';

	/// en: 'or'
	String get or => 'or';

	/// en: 'An unexpected error occured. Please try again later.'
	String get unknown_error => 'An unexpected error occured. Please try again later.';

	/// en: 'Do you really want to delete your account?'
	String get delete_account => 'Do you really want to delete your account?';

	/// en: 'This action can not be undone. All your data will be wiped!'
	String get delete_account_info => 'This action can not be undone. All your data will be wiped!';

	/// en: 'To confirm the deletion of your account, please use your password.'
	String get delete_account_info_password => 'To confirm the deletion of your account, please use your password.';

	/// en: 'To delete your account, please sign out and sign in again to reauthenticate.'
	String get delete_reauthenticate => 'To delete your account, please sign out and sign in again to reauthenticate.';

	/// en: 'Accoun succesfully deleted.'
	String get delete_success => 'Accoun succesfully deleted.';

	/// en: 'Delete account'
	String get delete_account_name => 'Delete account';

	/// en: 'Forgotten password?'
	String get forgot_password => 'Forgotten password?';

	/// en: 'Password reset'
	String get password_reset => 'Password reset';

	/// en: 'Submit'
	String get submit => 'Submit';

	/// en: 'Do you really want to reset your password?'
	String get really_reset_password => 'Do you really want to reset your password?';

	/// en: 'Password reset link was sent to your e-mail.'
	String get mail_sent => 'Password reset link was sent to your e-mail.';

	/// en: 'E-mail already in use. Please log in.'
	String get account_with_email_exists => 'E-mail already in use. Please log in.';

	/// en: 'Generate a PDF report'
	String get pdf_report_creation => 'Generate a PDF report';

	/// en: 'Creates a document for sharing. Includes records from the eating habits, challenging behaviours, and good habits.'
	String get pdf_report_creation_desc => 'Creates a document for sharing. Includes records from the eating habits, challenging behaviours, and good habits.';

	/// en: 'Incorrect password'
	String get incorrect_password => 'Incorrect password';

	/// en: 'After creating a person, it will be possible to track their eating habits, challenging behaviour, and good habits. You can also add additional people – their records will be kept separate. To access records for another created person, simply select them in this menu. Visual supports and cards are not unique to a specific person.'
	String get add_person_info => 'After creating a person, it will be possible to track their eating habits, challenging behaviour, and good habits. You can also add additional people – their records will be kept separate. To access records for another created person, simply select them in this menu. Visual supports and cards are not unique to a specific person.';

	/// en: 'Since when (and possibly until when) is this record valid?'
	String get from_to_info => 'Since when (and possibly until when) is this record valid?';

	/// en: 'Does the person eat this food or not?'
	String get is_eating_info => 'Does the person eat this food or not?';

	/// en: 'Photo of the meal, food item, or ingredient.'
	String get eating_habit_photo_info => 'Photo of the meal, food item, or ingredient.';

	/// en: 'Name of the meal, food item, or ingredient...'
	String get eating_habit_name => 'Name of the meal, food item, or ingredient...';

	/// en: 'Since when is this record valid?'
	String get from_info => 'Since when is this record valid?';

	/// en: 'Is this behaviour occuring?'
	String get behaviour_occuring_info => 'Is this behaviour occuring?';

	/// en: 'How long did this behaviour last, and when did it occur?'
	String get challenging_behaviour_duration_info => 'How long did this behaviour last, and when did it occur?';

	/// en: 'Who was present?'
	String get challenging_behaviour_people_info => 'Who was present?';

	/// en: 'Cards are used to fill the visual schedule/diagram. When you click "Add Step", a list of cards will appear — just select any card and it will be added to the schedule. To change the order of steps, use the horizontal icon on the right side of the row for the corresponding card.'
	String get visual_schedule_info => 'Cards are used to fill the visual schedule/diagram. When you click "Add Step", a list of cards will appear — just select any card and it will be added to the schedule. To change the order of steps, use the horizontal icon on the right side of the row for the corresponding card.';

	/// en: 'Cards are used to fill the First/Then board. When you click "First" or "Then", a list of cards will appear — just select any card and it will be added to the board.'
	String get first_then_board_info => 'Cards are used to fill the First/Then board. When you click "First" or "Then", a list of cards will appear — just select any card and it will be added to the board.';

	/// en: 'Do you really want to clear the keyboard?'
	String get clear_keyboard_ask => 'Do you really want to clear the keyboard?';

	/// en: 'If you are not in a folder, all cards and folders will be deleted. If you are inside a folder, only the cards and folders in that folder will be deleted. This action can not be undone'
	String get clear_keyboard_ask_additional => 'If you are not in a folder, all cards and folders will be deleted. If you are inside a folder, only the cards and folders in that folder will be deleted. This action can not be undone';

	/// en: 'Choose layout'
	String get choose_layout => 'Choose layout';

	/// en: '2 cards per row (large)'
	String get two_large => '2 cards per row (large)';

	/// en: '4 cards per row (medium)'
	String get four_medium => '4 cards per row (medium)';

	/// en: '6 cards per row (small)'
	String get six_small => '6 cards per row (small)';

	/// en: 'Visual diagrams, schedules, and first-then tables. They require cards to be created. They are not tied to a person.'
	String get visual_supports_desc => 'Visual diagrams, schedules, and first-then tables. They require cards to be created. They are not tied to a person.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'good_day' => 'Hello!',
			'sign_in' => 'Please sign in to use AutToolkit',
			'sign_in_google' => 'Sign in with Google',
			'sign_in_mail' => 'Sign in with Email',
			'password' => 'Password',
			'password_again' => 'Confirm password',
			'no_account' => 'No account yet?',
			'create_account' => 'Create account using an e-mail address',
			'log_in_button' => 'Log in',
			'no_sign_in_details' => 'Missing e-mail or password',
			'passwords_dont_match' => 'Passwords don\'t match',
			'invalid_mail' => 'Invalid e-mail address',
			'invalid_password' => 'Password must contain at elast 6 characters',
			'invalid_email_password' => 'Incorrect e-mail or password',
			'sign_in_button' => 'Sign in',
			'cancel' => 'Cancel',
			'home' => 'Home',
			'settings' => 'Settings',
			'kid_mode_button' => 'Child app mode',
			'signed_in_as' => 'Signed in as: ',
			'log_out' => 'Log out',
			'app_language' => 'App language',
			'change' => 'Change',
			'email' => 'E-mail',
			'enter_details' => 'Enter details',
			'really_log_out' => 'Do you really want to log out?',
			'yes' => 'Yes',
			'no' => 'No',
			'change_app_language' => 'Change app language',
			'dark_mode_toggle' => 'Dark mode',
			'good_habits' => 'Habits',
			'good_habits_desc' => 'Autistic children often prefer strict routines and predictability.',
			'bad_habits' => 'Bad habits',
			'eating_habits' => 'Eating habits',
			'eating_habits_desc' => 'Autistic children often eat selectively due to sensory sensitivities.',
			'is_eating' => 'Eats',
			'is_not_eating' => 'Does not eat',
			'active' => 'Active',
			'inactive' => 'Inactive',
			'search' => 'Search',
			'no_entries' => 'No entries',
			'from' => 'From',
			'to' => 'To',
			'notes' => 'Notes',
			'really_delete_object' => 'Do you really wish to delete ',
			'not_set' => 'Not set',
			'edit' => 'Edit',
			'name' => 'Name',
			'please_enter_name' => 'Please enter a name',
			'save' => 'Save',
			'ascending' => 'Ascending',
			'descending' => 'Descending',
			'sort_by' => 'Sort by',
			'date' => 'Date',
			'filters_and_sorting' => 'Filters and sorting',
			'filters' => 'Filters',
			'sort' => 'Sort by',
			'challenging_behaviour' => 'Challenging behaviour',
			'challenging_behaviour_desc' => 'Autistic children may show challenging behavior when overwhelmed or unable to communicate needs.',
			'occuring' => 'Occuring',
			'not_occuring' => 'Not occuring',
			'location' => 'Location',
			'please_enter_location' => 'Please enter a location',
			'duration' => 'Duration',
			'please_enter_duration' => 'Please enter duration',
			'invalid_value' => 'Invalid value',
			'one_minute' => 'Minute',
			'few_minutes' => 'Minutes',
			'many_minutes' => 'Minutes',
			'circumstances' => 'Circumstances',
			'people_present' => 'People present',
			'outcome' => 'Outcome',
			'reflection' => 'Reflection',
			'add_new_entry' => 'Add new entry',
			'create' => 'Create',
			'after_typing_enter_submit' => 'After typing press "Enter" to save',
			'minute' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, zero: 'Minutes', one: 'Minute', other: 'Minutes', ), 
			'mon' => 'Mon',
			'tue' => 'Tue',
			'wed' => 'Wed',
			'thu' => 'Thu',
			'fri' => 'Fri',
			'sat' => 'Sat',
			'sun' => 'Sun',
			'entry' => 'Entry',
			'close' => 'Close',
			'managed_people' => 'Managed people',
			'add_managed_person' => 'Add a person',
			'load_image' => 'Add image',
			'change_image' => 'Change image',
			'delete_image' => 'Delete image',
			'change_saved' => 'Change saved',
			'image_changed' => 'Image was changed',
			'image_deleted' => 'Image was deleted',
			'entry_added' => 'Entry added',
			'currently_managed_person' => 'Currently managed person:',
			'crop_image' => 'Crop image',
			'cards' => 'Cards',
			'cards_desc' => 'Cards are used in the AAC board and visual supports. They are not tied to a person. By long-pressing the card, you activate the mode for generating printable cards.',
			'visual_sequence_boards' => 'Visual sequence boards',
			'visual_sequence_boards_desc' => 'Visual sequence boards management',
			'arasaac_icons' => 'ARASAAC Icons',
			'create_card' => 'Create cards',
			'create_card_decision' => 'What source would like to use for the icon?',
			'from_gallery' => 'Gallery',
			'no_icons_found' => 'No icons found for given search query.',
			'use_this_image' => 'Use this icon?',
			'detail' => 'Detail',
			'delete' => 'Delete',
			'cant_undo_action' => 'This action cannot be undone.',
			'error_occured' => 'An error occured',
			'no_image_set' => 'No image was set.',
			'registration_succesful' => 'Registration was succesful. You can now log in.',
			'visual_supports' => 'Visual supports',
			'visual_schedules' => 'Visual schedules',
			'visual_diagrams' => 'Vizuálne diagramy',
			'first_then_boards' => 'First–Then boards',
			'visual_diagram_desc' => 'A Visual Diagram represents concepts, processes, or relationships in a visual format, helping to organize information and understand connections.',
			'first_then_boards_desc' => 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.',
			'visual_schedule_desc' => 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.',
			'first' => 'First',
			'then' => 'Then',
			'steps' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Step', few: 'Steps', many: 'Steps', other: 'Steps', ), 
			'add_step' => 'Add step',
			'done' => 'Done!',
			'tts_settings' => 'Voice settings',
			'tts_rate' => 'Rate',
			'tts_volume' => 'Volume',
			'tts_pitch' => 'Pitch',
			'tts_test' => 'Voice test',
			'card_name_language_info' => 'When creating a new card, the entered name is automatically used for all languages. To change the name in another language, switch the app language and then edit the card again. When editing an existing card, the change will be saved only for the currently active app language.',
			'noun' => 'Noun',
			'pronoun' => 'Pronoun',
			'verb' => 'Verb',
			'adjective' => 'Adjective',
			'preposition' => 'Preposition',
			'question' => 'Question word',
			'negation_important' => 'Negation & important words',
			'adverb' => 'Adverb',
			'conjunction' => 'Conjunction',
			'determiner' => 'Determiner',
			'please_choose_word_category' => 'Please choose a word type',
			'word_category' => 'Word type',
			'data_sync' => 'Syncing data, please wait...',
			'unlocking' => 'Unlocking...',
			'locking' => 'Keyboard is locked',
			'hold_to_unlock' => 'Keep holding the button for',
			'second' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'second', few: 'seconds', many: 'Seconds', other: 'seconds', ), 
			'to_unlock_hold' => 'To unlock the keyboard please hold the button for',
			'grid_settings' => 'Keyboard settings',
			'grid_size' => 'Keyboard size',
			'rows' => 'Rows',
			'cols' => 'Columns',
			'add_card' => 'Add a card',
			'add_folder' => 'Add a folder',
			'folder_name' => 'Folder name',
			'folder_name_hint' => 'e. g. Food, Body, ...',
			'choose_cover_and_save' => 'Choose icon and create folder',
			'preparing_pdf' => 'Preparing PDF...',
			'or' => 'or',
			'unknown_error' => 'An unexpected error occured. Please try again later.',
			'delete_account' => 'Do you really want to delete your account?',
			'delete_account_info' => 'This action can not be undone. All your data will be wiped!',
			'delete_account_info_password' => 'To confirm the deletion of your account, please use your password.',
			'delete_reauthenticate' => 'To delete your account, please sign out and sign in again to reauthenticate.',
			'delete_success' => 'Accoun succesfully deleted.',
			'delete_account_name' => 'Delete account',
			'forgot_password' => 'Forgotten password?',
			'password_reset' => 'Password reset',
			'submit' => 'Submit',
			'really_reset_password' => 'Do you really want to reset your password?',
			'mail_sent' => 'Password reset link was sent to your e-mail.',
			'account_with_email_exists' => 'E-mail already in use. Please log in.',
			'pdf_report_creation' => 'Generate a PDF report',
			'pdf_report_creation_desc' => 'Creates a document for sharing. Includes records from the eating habits, challenging behaviours, and good habits.',
			'incorrect_password' => 'Incorrect password',
			'add_person_info' => 'After creating a person, it will be possible to track their eating habits, challenging behaviour, and good habits. You can also add additional people – their records will be kept separate. To access records for another created person, simply select them in this menu. Visual supports and cards are not unique to a specific person.',
			'from_to_info' => 'Since when (and possibly until when) is this record valid?',
			'is_eating_info' => 'Does the person eat this food or not?',
			'eating_habit_photo_info' => 'Photo of the meal, food item, or ingredient.',
			'eating_habit_name' => 'Name of the meal, food item, or ingredient...',
			'from_info' => 'Since when is this record valid?',
			'behaviour_occuring_info' => 'Is this behaviour occuring?',
			'challenging_behaviour_duration_info' => 'How long did this behaviour last, and when did it occur?',
			'challenging_behaviour_people_info' => 'Who was present?',
			'visual_schedule_info' => 'Cards are used to fill the visual schedule/diagram. When you click "Add Step", a list of cards will appear — just select any card and it will be added to the schedule. To change the order of steps, use the horizontal icon on the right side of the row for the corresponding card.',
			'first_then_board_info' => 'Cards are used to fill the First/Then board. When you click "First" or "Then", a list of cards will appear — just select any card and it will be added to the board.',
			'clear_keyboard_ask' => 'Do you really want to clear the keyboard?',
			'clear_keyboard_ask_additional' => 'If you are not in a folder, all cards and folders will be deleted. If you are inside a folder, only the cards and folders in that folder will be deleted. This action can not be undone',
			'choose_layout' => 'Choose layout',
			'two_large' => '2 cards per row (large)',
			'four_medium' => '4 cards per row (medium)',
			'six_small' => '6 cards per row (small)',
			'visual_supports_desc' => 'Visual diagrams, schedules, and first-then tables. They require cards to be created. They are not tied to a person.',
			_ => null,
		};
	}
}
