import '../../i18n/strings.g.dart';

class AppConstants {

  static final double BASE_APP_UI_PADDING = 16.0;

  static const String NAME_ASC = 'NAME_ASC';
  static const String NAME_DESC = 'NAME_DESC';
  static const String DATE_ASC = 'DATE_ASC';
  static const String DATE_DESC = 'DATE_DESC';

  static const String IS_EATING = 'IS_EATING';
  static const String IS_NOT_EATING = 'IS_NOT_EATING';
  static const String IS_ACTIVE = 'IS_ACTIVE';
  static const String IS_NOT_ACTIVE = 'IS_NOT_ACTIVE';

  static String getLabel(String key) {
    switch(key) {
      case NAME_ASC: return '${t.name} (${t.ascending})';
      case NAME_DESC: return '${t.name} (${t.descending})';
      case DATE_ASC: return '${t.date} (${t.ascending})';
      case DATE_DESC: return '${t.date} (${t.descending})';
      case IS_EATING: return t.is_eating;
      case IS_NOT_EATING: return t.is_not_eating;
      case IS_ACTIVE: return t.active;
      case IS_NOT_ACTIVE: return t.inactive;
      default: return key;
    }
  }

}