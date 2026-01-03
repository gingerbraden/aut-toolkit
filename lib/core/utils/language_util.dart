class LanguageUtil {

  static final LANGUAGES = {"sk", "en", "cz"};

  static Map<String, String> setCardNameToLanguage(Map<String, String> currMap, String currLocale, String newName) {
    Map<String, String> ret = currMap;
    if (ret.isEmpty) {
      for (String lang in LANGUAGES) {
        ret[lang] = newName;
      }
    } else {
      ret[currLocale] = newName;
    }
    return ret;
  }

}