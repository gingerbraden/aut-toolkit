import 'dart:convert';

import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';

import '../../../../../main.dart';
import '../../../../../core/model/sync_entity.dart';
import '../../../../card_management/data/model/user_card_entity.dart';
import '../../../visual_lists/data/model/visual_list_entity.dart';
import '../../../visual_lists/data/model/visual_list_remote_entity.dart';
import '../../../visual_lists/domain/model/visual_list.dart';

extension VisualListEntityMapper on VisualListEntity {
  VisualList toModel() {
    final stepModels = steps.map((e) => e.toModel()).toList();

    if (stepsOrderJson != null && stepsOrderJson!.isNotEmpty) {
      final Map<String, dynamic> decodedMap = jsonDecode(stepsOrderJson!);

      final Map<int, String> orderMap = decodedMap.map(
            (key, value) => MapEntry(int.parse(key), value as String),
      );

      stepModels.sort((a, b) {
        final orderA = orderMap.entries
            .firstWhere(
              (entry) => entry.value == a.remoteId.toString(),
          orElse: () => const MapEntry(99999, ""),
        )
            .key;

        final orderB = orderMap.entries
            .firstWhere(
              (entry) => entry.value == b.remoteId.toString(),
          orElse: () => const MapEntry(99999, ""),
        )
            .key;

        return orderA.compareTo(orderB);
      });
    }

    return VisualList(
      id: id,
      userId: userId,
      name: name,
      steps: stepModels,
      isVisualDiagram: isVisualDiagram,
      isVisualSchedule: isVisualSchedule,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
      updatedAt: updatedAt,
    );
  }
}

extension VisualListMapper on VisualList {
  VisualListEntity toEntity() {
    final entity = VisualListEntity(
      id: id ?? 0,
      userId: userId,
      name: name,
      isVisualSchedule: isVisualSchedule,
      isVisualDiagram: isVisualDiagram,
      updatedAt: updatedAt,
    );

    final stepEntities = steps.map((e) => e.toEntity()).toList();
    entity.steps
      ..clear()
      ..addAll(stepEntities);

    final orderMap = stepEntities
        .asMap()
        .map((index, step) => MapEntry(index.toString(), step.remoteId.toString()));

    entity.stepsOrderJson = json.encode(orderMap);

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;

    return entity;
  }
}

extension VisualListEntityToRemote on VisualListEntity {
  VisualListRemoteEntity toRemote() {
    return VisualListRemoteEntity(
      localId: id,
      userId: userId,
      name: name,
      isVisualSchedule: isVisualSchedule,
      isVisualDiagram: isVisualDiagram,
      stepsOrderJson: stepsOrderJson,
      updatedAt: updatedAt,
      steps: steps.map((e) => e.remoteId!).toList(),
    )
      ..isDeleted = isDeleted
      ..isSynced = true
      ..pendingAction = PendingAction.NONE
      ..remoteId = remoteId;
  }
}

extension VisualListRemoteToEntity on VisualListRemoteEntity {
  VisualListEntity toEntity() {
    final entity = VisualListEntity(
      id: localId,
      userId: userId,
      name: name,
      isVisualSchedule: isVisualSchedule,
      isVisualDiagram: isVisualDiagram,
      updatedAt: updatedAt,
    );

    entity.steps
      ..clear()
      ..addAll(
        steps
            .map((remoteId) => objectbox.cardBox.getByRemoteId(remoteId))
            .whereType<UserCardEntity>()
            .toList(),
      );

    entity.stepsOrderJson = stepsOrderJson;

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;

    return entity;
  }
}
