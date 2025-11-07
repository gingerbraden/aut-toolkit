import 'package:objectbox/objectbox.dart';

import '../model/user_card_entity.dart';

class CardLocalSource {
  final Box<UserCardEntity> cardBox;

  CardLocalSource(this.cardBox);

  List<UserCardEntity> getAll() => cardBox.getAll();

  int put(UserCardEntity entity) => cardBox.put(entity);

  void remove(int id) => cardBox.remove(id);
}
