import 'dart:ui';

import '../../features/card_management/domain/model/user_card.dart';
import '../../i18n/strings.g.dart';

class CardUtil {
  static const Map<WordCategory, Color> wordCategoryColourMap = {
    WordCategory.NOUN: Color(0xFFFFB74D),
    WordCategory.PRONOUN: Color(0xFFFFF176),
    WordCategory.VERB: Color(0xFFA5D6A7),
    WordCategory.ADJECTIVE: Color(0xFF81D4FA),
    WordCategory.PREPOSITION: Color(0xFFF48FB1),
    WordCategory.QUESTION: Color(0xFFB39DDB),
    WordCategory.NEGATION_IMPORTANT: Color(0xFFEF9A9A),
    WordCategory.ADVERB: Color(0xFFD7B899),
    WordCategory.CONJUNCTION: Color(0xFFFFFFFF),
    WordCategory.DETERMINER: Color(0xFF616161),
  };

  static Color getColorForWordCat(WordCategory wordCat) {
    if (wordCategoryColourMap.containsKey(wordCat)) {
      return wordCategoryColourMap[wordCat]!;
    }
    return Color(0xFFFFFFFF);
  }

  static String getWordCategoryLabel(WordCategory category) {
    switch (category) {
      case WordCategory.NOUN:
        return t.noun;
      case WordCategory.PRONOUN:
        return t.pronoun;
      case WordCategory.VERB:
        return t.verb;
      case WordCategory.ADJECTIVE:
        return t.adjective;
      case WordCategory.PREPOSITION:
        return t.preposition;
      case WordCategory.QUESTION:
        return t.question;
      case WordCategory.NEGATION_IMPORTANT:
        return t.negation_important;
      case WordCategory.ADVERB:
        return t.adverb;
      case WordCategory.CONJUNCTION:
        return t.conjunction;
      case WordCategory.DETERMINER:
        return t.determiner;
    }
  }
}
