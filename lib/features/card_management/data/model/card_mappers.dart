import 'dart:convert';

import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

import '../../../../core/model/sync_entity.dart';
import 'user_card_remote_entity.dart';

extension UserCardEntityMapper on UserCardEntity {
  UserCard toModel() => UserCard(
    id: id,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    names: Map<String, String>.from(jsonDecode(namesJson)),
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: PendingAction.values[pendingAction],
    remoteId: remoteId,
    updatedAt: updatedAt,
    remoteImgPath: remoteImgPath,
  );
}

extension UserCardMapper on UserCard {
  UserCardEntity toEntity() => UserCardEntity(
    id: id ?? 0,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    namesJson: jsonEncode(names),
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
    updatedAt: updatedAt,
    remoteImgPath: remoteImgPath,
  );
}

extension UserCardEntityToRemote on UserCardEntity {
  UserCardRemoteEntity toRemote() =>
      UserCardRemoteEntity(
          localId: id,
          arasaacId: arasaacId,
          userId: userId,
          localImgPath: localImgPath,
          namesJson: namesJson,
          updatedAt: updatedAt,
          remoteImagePath: remoteImgPath,
        )
        ..isDeleted = isDeleted
        ..isSynced = isSynced
        ..pendingAction = PendingAction.values[pendingAction]
        ..remoteId = remoteId;
}

extension UserCardRemoteToEntity on UserCardRemoteEntity {
  UserCardEntity toEntity() => UserCardEntity(
    id: localId,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    namesJson: namesJson,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
    updatedAt: updatedAt,
    remoteImgPath: remoteImagePath,
  );
}
