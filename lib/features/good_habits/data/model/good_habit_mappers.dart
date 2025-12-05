import 'package:aut_toolkit/features/good_habits/data/model/good_habit_entity.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';

import '../../../../core/model/sync_entity.dart';
import 'good_habit_remote_entity.dart';

extension GoodHabitEntityMapper on GoodHabitEntity {
  GoodHabit toModel() => GoodHabit(
    id: id,
    from: from,
    name: name,
    description: description,
    userId: userId,
    isOcuringFlag: isOccuringFlag,
    selectedPersonId: selectedPersonId,
    to: to,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: PendingAction.values[pendingAction],
    remoteId: remoteId
  );
}

extension GoodHabitMapper on GoodHabit {
  GoodHabitEntity toEntity() => GoodHabitEntity(
    id: id ?? 0,
    from: from,
    name: name,
    description: description,
    userId: userId,
    isOccuringFlag: isOcuringFlag,
    selectedPersonId: selectedPersonId,
    to: to,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId
  );
}

extension GoodHabitEntityToRemote on GoodHabitEntity {
  GoodHabitRemoteEntity toRemote() => GoodHabitRemoteEntity(
    localId: id,
    from: from,
    userId: userId,
    name: name,
    description: description,
    isOccuringFlag: isOccuringFlag,
    selectedPersonId: selectedPersonId,
    to: to,
    updatedAt: updatedAt,
  )
    ..isDeleted = isDeleted
    ..isSynced = isSynced
    ..pendingAction = PendingAction.values[pendingAction]
    ..remoteId = remoteId;
}

extension GoodHabitRemoteToEntity on GoodHabitRemoteEntity {
  GoodHabitEntity toEntity() => GoodHabitEntity(
    id: localId,
    from: from,
    name: name,
    description: description,
    userId: userId,
    isOccuringFlag: isOccuringFlag,
    selectedPersonId: selectedPersonId,
    to: to,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
  );
}
