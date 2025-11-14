import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/objectbox.g.dart';

import '../../domain/model/first_then_board.dart';
import 'first_then_board_entity.dart';

extension FirstThenBoardEntityMapper on FirstThenBoardEntity {
  FirstThenBoard toModel() {
    return FirstThenBoard(
      id: id,
      userId: userId,
      first:
          first.target?.toModel() ??
          UserCard(id: 0, userId: '', names: {}, localImgPath: ''),
      then:
          then.target?.toModel() ??
          UserCard(id: 0, userId: '', names: {}, localImgPath: ''),
      name: name,
    );
  }
}

extension FirstThenBoardMapper on FirstThenBoard {
  FirstThenBoardEntity toEntity() {
    final entity = FirstThenBoardEntity(
      id: id ?? 0,
      userId: userId,
      first: ToOne<UserCardEntity>(),
      then: ToOne<UserCardEntity>(),
      name: name,
    );

    entity.first.target = first.toEntity();
    entity.then.target = then.toEntity();

    return entity;
  }
}
