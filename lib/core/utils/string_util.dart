class StringUtils {
  bool isMailValid(String mail) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(mail);
  }

  String removeDiacritics(String str) {
    const withDiacritics =    'áäčďéíĺľňóôŕšťúýžÁÄČĎÉÍĹĽŇÓÔŔŠŤÚÝŽ';
    const withoutDiacritics = 'aacdeillnoorstuyzAACDEILLNOORSTUYZ';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }
}
