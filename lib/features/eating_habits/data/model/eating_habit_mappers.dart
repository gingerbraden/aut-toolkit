import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';

import '../../../../core/model/sync_entity.dart';
import 'eating_habit_remote_entity.dart';

extension EatingHabitEntityMapper on EatingHabitEntity {
  EatingHabit toModel() => EatingHabit(
    id: id,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
    selectedPersonId: selectedPersonId,
    imageFilePath: imageFilePath,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: PendingAction.values[pendingAction],
    remoteId: remoteId,
    remoteImgPath: remoteImgPath
  );
}

extension EatingHabitMapper on EatingHabit {
  EatingHabitEntity toEntity() => EatingHabitEntity(
    id: id ?? 0,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
    selectedPersonId: selectedPersonId,
    imageFilePath: imageFilePath,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    isSynced: isSynced,
    pendingAction: pendingAction.index,
    remoteId: remoteId,
    remoteImgPath: remoteImgPath
  );
}

extension EatingHabitEntityToRemote on EatingHabitEntity {
  EatingHabitRemoteEntity toRemote() => EatingHabitRemoteEntity(
    localId: id,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
    selectedPersonId: selectedPersonId,
    imageFilePath: imageFilePath,
    updatedAt: updatedAt,
    remoteImagePath: remoteImgPath
  )
    ..remoteId = remoteId
    ..isSynced = isSynced
    ..isDeleted = isDeleted
    ..pendingAction = PendingAction.values[pendingAction];
}

extension EatingHabitRemoteToEntity on EatingHabitRemoteEntity {
  EatingHabitEntity toEntity() => EatingHabitEntity(
    id: localId,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
    selectedPersonId: selectedPersonId,
    imageFilePath: imageFilePath,
    updatedAt: updatedAt,
    remoteId: remoteId,
    isSynced: isSynced,
    isDeleted: isDeleted,
    pendingAction: pendingAction.index,
    remoteImgPath: remoteImagePath
  );
}

