import '../../i18n/strings.g.dart';

class DateUtil {
  static String returnDateInStringFormat(DateTime? date) {
    if (date == null) return '';
    return '${date.day}.${date.month}.${date.year}';
  }
  static String returnDateInStringFormatWithTime(DateTime? date) {
    if (date == null) return '';
    return '${date.day}.${date.month}.${date.year} o ${date.hour}:${date.minute < 10 ? '0${date.minute}' : '${date.minute}'}';
  }
  static String getDayOfWeekString(int n) {
    switch(n) {
      case 1:
        return t.mon;
      case 2:
        return t.tue;
      case 3:
        return t.wed;
      case 4:
        return t.thu;
      case 5:
        return t.fri;
      case 6:
        return t.sat;
      case 7:
        return t.sun;
    }
    return "";
  }
  static bool isTodayBetweenTwoDates(DateTime date1, DateTime? date2) {
    if (date1.isBefore(DateTime.now()) && date2 == null) {
      return true;
    } else if (!date1.isBefore(DateTime.now()) && date2 == null) {
      return false;
    }

    if (date2 == null) return false;

    if (date1.isBefore(DateTime.now()) && date2.isAfter(DateTime.now())) {
      return true;
    }
    return false;



  }
}
