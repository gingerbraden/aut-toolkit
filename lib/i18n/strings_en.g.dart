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

	/// en: 'Create account'
	String get create_account => 'Create account';

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

	/// en: 'Cards are used in the AAC board, and can be used inside processural diagrams.'
	String get cards_desc => 'Cards are used in the AAC board, and can be used inside processural diagrams.';

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

	/// en: 'First–Then boards'
	String get first_then_boards => 'First–Then boards';

	/// en: 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.'
	String get first_then_boards_desc => 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.';

	/// en: 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.'
	String get visual_schedule_desc => 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'good_day': return 'Hello!';
			case 'sign_in': return 'Please sign in to use AutToolkit';
			case 'sign_in_google': return 'Sign in with Google';
			case 'sign_in_mail': return 'Sign in with Email';
			case 'password': return 'Password';
			case 'password_again': return 'Confirm password';
			case 'no_account': return 'No account yet?';
			case 'create_account': return 'Create account';
			case 'log_in_button': return 'Log in';
			case 'no_sign_in_details': return 'Missing e-mail or password';
			case 'passwords_dont_match': return 'Passwords don\'t match';
			case 'invalid_mail': return 'Invalid e-mail address';
			case 'invalid_password': return 'Password must contain at elast 6 characters';
			case 'invalid_email_password': return 'Incorrect e-mail or password';
			case 'sign_in_button': return 'Sign in';
			case 'cancel': return 'Cancel';
			case 'home': return 'Home';
			case 'settings': return 'Settings';
			case 'kid_mode_button': return 'Child app mode';
			case 'signed_in_as': return 'Signed in as: ';
			case 'log_out': return 'Log out';
			case 'app_language': return 'App language';
			case 'change': return 'Change';
			case 'email': return 'E-mail';
			case 'enter_details': return 'Enter details';
			case 'really_log_out': return 'Do you really want to log out?';
			case 'yes': return 'Yes';
			case 'no': return 'No';
			case 'change_app_language': return 'Change app language';
			case 'dark_mode_toggle': return 'Dark mode';
			case 'good_habits': return 'Habits';
			case 'good_habits_desc': return 'Autistic children often prefer strict routines and predictability.';
			case 'bad_habits': return 'Bad habits';
			case 'eating_habits': return 'Eating habits';
			case 'eating_habits_desc': return 'Autistic children often eat selectively due to sensory sensitivities.';
			case 'is_eating': return 'Eats';
			case 'is_not_eating': return 'Does not eat';
			case 'active': return 'Active';
			case 'inactive': return 'Inactive';
			case 'search': return 'Search';
			case 'no_entries': return 'No entries';
			case 'from': return 'From';
			case 'to': return 'To';
			case 'notes': return 'Notes';
			case 'really_delete_object': return 'Do you really wish to delete ';
			case 'not_set': return 'Not set';
			case 'edit': return 'Edit';
			case 'name': return 'Name';
			case 'please_enter_name': return 'Please enter a name';
			case 'save': return 'Save';
			case 'ascending': return 'Ascending';
			case 'descending': return 'Descending';
			case 'sort_by': return 'Sort by';
			case 'date': return 'Date';
			case 'filters_and_sorting': return 'Filters and sorting';
			case 'filters': return 'Filters';
			case 'sort': return 'Sort by';
			case 'challenging_behaviour': return 'Challenging behaviour';
			case 'challenging_behaviour_desc': return 'Autistic children may show challenging behavior when overwhelmed or unable to communicate needs.';
			case 'occuring': return 'Occuring';
			case 'not_occuring': return 'Not occuring';
			case 'location': return 'Location';
			case 'please_enter_location': return 'Please enter a location';
			case 'duration': return 'Duration';
			case 'please_enter_duration': return 'Please enter duration';
			case 'invalid_value': return 'Invalid value';
			case 'one_minute': return 'Minute';
			case 'few_minutes': return 'Minutes';
			case 'many_minutes': return 'Minutes';
			case 'circumstances': return 'Circumstances';
			case 'people_present': return 'People present';
			case 'outcome': return 'Outcome';
			case 'reflection': return 'Reflection';
			case 'add_new_entry': return 'Add new entry';
			case 'create': return 'Create';
			case 'after_typing_enter_submit': return 'After typing press "Enter" to save';
			case 'minute': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: 'Minutes',
				one: 'Minute',
				other: 'Minutes',
			);
			case 'mon': return 'Mon';
			case 'tue': return 'Tue';
			case 'wed': return 'Wed';
			case 'thu': return 'Thu';
			case 'fri': return 'Fri';
			case 'sat': return 'Sat';
			case 'sun': return 'Sun';
			case 'entry': return 'Entry';
			case 'close': return 'Close';
			case 'managed_people': return 'Managed people';
			case 'add_managed_person': return 'Add a person';
			case 'load_image': return 'Add image';
			case 'change_image': return 'Change image';
			case 'delete_image': return 'Delete image';
			case 'change_saved': return 'Change saved';
			case 'image_changed': return 'Image was changed';
			case 'image_deleted': return 'Image was deleted';
			case 'entry_added': return 'Entry added';
			case 'currently_managed_person': return 'Currently managed person:';
			case 'crop_image': return 'Crop image';
			case 'cards': return 'Cards';
			case 'cards_desc': return 'Cards are used in the AAC board, and can be used inside processural diagrams.';
			case 'visual_sequence_boards': return 'Visual sequence boards';
			case 'visual_sequence_boards_desc': return 'Visual sequence boards management';
			case 'arasaac_icons': return 'ARASAAC Icons';
			case 'create_card': return 'Create cards';
			case 'create_card_decision': return 'What source would like to use for the icon?';
			case 'from_gallery': return 'Gallery';
			case 'no_icons_found': return 'No icons found for given search query.';
			case 'use_this_image': return 'Use this icon?';
			case 'detail': return 'Detail';
			case 'delete': return 'Delete';
			case 'cant_undo_action': return 'This action cannot be undone.';
			case 'error_occured': return 'An error occured';
			case 'no_image_set': return 'No image was set.';
			case 'registration_succesful': return 'Registration was succesful. You can now log in.';
			case 'visual_supports': return 'Visual supports';
			case 'visual_schedules': return 'Visual schedules';
			case 'first_then_boards': return 'First–Then boards';
			case 'first_then_boards_desc': return 'A First–Then Board helps understand and complete tasks by showing what needs to be done first and what preferred activity will follow.';
			case 'visual_schedule_desc': return 'A Visual Schedule shows the order of daily activities or steps within a task, helping understand routines, reduce anxiety, and become more independent.';
			default: return null;
		}
	}
}

