import '../../../../objectbox.g.dart';
import '../model/user_card_entity.dart';

class CardLocalSource {
  final Box<UserCardEntity> cardBox;

  CardLocalSource(this.cardBox);

  List<UserCardEntity> getAll() => cardBox.getAll();

  UserCardEntity? getById(int id) => cardBox.get(id);

  UserCardEntity? getByRemoteId(String id) => cardBox.getByRemoteId(id);

  int put(UserCardEntity entity) => cardBox.put(entity);

  void remove(int id) => cardBox.remove(id);

  Stream<List<UserCardEntity>> watchAll() {
    final builder = cardBox.query();

    return builder.watch(triggerImmediately: true).map((query) {
      final result = query.find();
      return result;
    });
  }

  List<UserCardEntity> getAllPending() {
    final q = cardBox.query(UserCardEntity_.pendingAction.notEquals(0)).build();
    final result = q.find();
    q.close();
    return result;
  }
}
