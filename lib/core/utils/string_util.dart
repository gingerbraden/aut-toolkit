class StringUtils {
  bool isMailValid(String mail) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(mail);
  }
}
