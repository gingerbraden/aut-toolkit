import 'package:aut_toolkit/features/selected_person/data/model/selected_person_entity.dart';
import 'package:aut_toolkit/features/selected_person/data/model/selected_person_remote_entity.dart';
import 'package:aut_toolkit/features/selected_person/domain/model/selected_person.dart';

import '../../../../core/model/sync_entity.dart';

extension SelectedPersonEntityMapper on SelectedPersonEntity {
  SelectedPerson toModel() => SelectedPerson(
    id: id,
    name: name,
    userId: userId,
    isSelected: isSelected,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: PendingAction.values[pendingAction],
    remoteId: remoteId
  );
}

extension SelectedPersonMapper on SelectedPerson {
  SelectedPersonEntity toEntity() => SelectedPersonEntity(
    id: id ?? 0,
    name: name,
    userId: userId,
    isSelected: isSelected,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
  );
}

extension SelectedPersonEntityToRemote on SelectedPersonEntity {
  SelectedPersonRemoteEntity toRemote() => SelectedPersonRemoteEntity(
    localId: id,
    name: name,
    userId: userId,
    isSelected: isSelected,
    updatedAt: updatedAt,
  )
    ..isDeleted = isDeleted
    ..isSynced = true
    ..pendingAction = PendingAction.NONE
    ..remoteId = remoteId;
}

extension SelectedPersonRemoteToEntity on SelectedPersonRemoteEntity {
  SelectedPersonEntity toEntity() => SelectedPersonEntity(
    id: localId,
    name: name,
    userId: userId,
    isSelected: isSelected,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
  );
}
