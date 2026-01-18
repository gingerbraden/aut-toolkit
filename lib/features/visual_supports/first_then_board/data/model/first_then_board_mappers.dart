import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/objectbox.g.dart';

import '../../../../../core/model/sync_entity.dart';
import '../../../../../main.dart';
import '../../domain/model/first_then_board.dart';
import 'first_then_board_entity.dart';
import 'first_then_board_remote_entity.dart';

extension FirstThenBoardEntityMapper on FirstThenBoardEntity {
  FirstThenBoard toModel() {
    return FirstThenBoard(
      id: id,
      userId: userId,
      first:
          first.target?.toModel() ??
          UserCard(
            id: 0,
            userId: '',
            names: {},
            localImgPath: '',
            updatedAt: DateTime.now(),
            remoteImgPath: '',
          ),
      then:
          then.target?.toModel() ??
          UserCard(
            id: 0,
            userId: '',
            names: {},
            localImgPath: '',
            updatedAt: DateTime.now(),
            remoteImgPath: '',
          ),
      name: name,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
      updatedAt: updatedAt,
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
      updatedAt: updatedAt,
    );

    entity.first.target = first.toEntity();
    entity.then.target = then.toEntity();

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;
    entity.updatedAt = updatedAt;

    return entity;
  }
}

extension FirstThenBoardEntityToRemote on FirstThenBoardEntity {
  FirstThenBoardRemoteEntity toRemote() {
    return FirstThenBoardRemoteEntity(
        localId: id,
        userId: userId,
        first: first.target!.remoteId!,
        then: then.target!.remoteId!,
        name: name,
        updatedAt: updatedAt,
      )
      ..isDeleted = isDeleted
      ..isSynced = true
      ..pendingAction = PendingAction.NONE
      ..remoteId = remoteId;
  }
}

extension FirstThenBoardRemoteToEntity on FirstThenBoardRemoteEntity {
  FirstThenBoardEntity toEntity() {
    final entity = FirstThenBoardEntity(
      id: localId,
      userId: userId,
      first: ToOne<UserCardEntity>(),
      then: ToOne<UserCardEntity>(),
      name: name,
      updatedAt: updatedAt,
    );

    if (first.isNotEmpty) {
      entity.first.target = objectbox.cardBox.getByRemoteId(first);
    }
    if (then.isNotEmpty) {
      entity.then.target = objectbox.cardBox.getByRemoteId(then);
    }

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;
    entity.updatedAt = updatedAt;

    return entity;
  }
}
