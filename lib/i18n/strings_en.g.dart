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

	/// en: 'Bad habits'
	String get bad_habits => 'Bad habits';

	/// en: 'Eating habits'
	String get eating_habits => 'Eating habits';

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

	/// en: 'Occuring'
	String get occuring => 'Occuring';

	/// en: 'Not occuring'
	String get not_occuring => 'Not occuring';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Please enter a location'
	String get please_enter_location => 'Please enter a location';

	/// en: 'Trvanie'
	String get duration => 'Trvanie';

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
			case 'bad_habits': return 'Bad habits';
			case 'eating_habits': return 'Eating habits';
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
			case 'occuring': return 'Occuring';
			case 'not_occuring': return 'Not occuring';
			case 'location': return 'Location';
			case 'please_enter_location': return 'Please enter a location';
			case 'duration': return 'Trvanie';
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
			default: return null;
		}
	}
}

