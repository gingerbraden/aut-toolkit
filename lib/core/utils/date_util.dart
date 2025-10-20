class DateUtil {
  static String returnDateInStringFormat(DateTime? date) {
    if (date == null) return '';
    return '${date.day}.${date.month}.${date.year}';
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
