import 'package:objectbox/objectbox.dart';

import '../../../../card_management/data/model/user_card_entity.dart';

@Entity()
class FirstThenBoardEntity {
  @Id()
  int id = 0;
  String userId;
  ToOne<UserCardEntity> first;
  ToOne<UserCardEntity> then;

  FirstThenBoardEntity({
    this.id = 0,
    required this.userId,
    required this.first,
    required this.then,
  });
}
