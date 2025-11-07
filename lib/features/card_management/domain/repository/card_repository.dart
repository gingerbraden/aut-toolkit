import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

abstract class CardRepository {
  List<UserCard> getAllCards();
  void saveCard(UserCard card);
  void deleteCard(UserCard card);
}
