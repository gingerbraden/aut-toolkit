import 'dart:convert';

import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';

import '../../domain/model/visual_list.dart';
import 'visual_list_entity.dart';

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
              (entry) => entry.value == a.id.toString(),
              orElse: () => const MapEntry(99999, ""),
            )
            .key;
        final orderB = orderMap.entries
            .firstWhere(
              (entry) => entry.value == b.id.toString(),
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
    );

    final stepEntities = steps.map((e) => e.toEntity()).toList();
    entity.steps..clear()..addAll(stepEntities);

    final orderMap = stepEntities
        .asMap()
        .map((index, step) => MapEntry(index.toString(), step.id.toString()));

    entity.stepsOrderJson = json.encode(orderMap);

    return entity;
  }
}
