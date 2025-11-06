import 'package:aut_toolkit/features/card_management/domain/model/card.dart';

abstract class CardRepository {
  List<Card> getAllCards();
  void saveCard(Card card);
  void deleteCard(Card card);
}
