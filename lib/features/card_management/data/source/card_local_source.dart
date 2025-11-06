import 'package:objectbox/objectbox.dart';

import '../model/card_entity.dart';

class CardLocalSource {
  final Box<CardEntity> cardBox;

  CardLocalSource(this.cardBox);

  List<CardEntity> getAll() => cardBox.getAll();

  int put(CardEntity entity) => cardBox.put(entity);

  void remove(int id) => cardBox.remove(id);
}
