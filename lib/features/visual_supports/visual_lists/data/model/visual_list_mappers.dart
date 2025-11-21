import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

import '../../domain/model/visual_list.dart';
import 'visual_list_entity.dart';

extension VisualListEntityMapper on VisualListEntity {
  VisualList toModel() {
    return VisualList(
      id: id,
      userId: userId,
      name: name,
      steps: steps.map((e) => e.toModel()).toList(),
      isVisualDiagram: isVisualDiagram,
      isVisualSchedule: isVisualSchedule
    );
  }
}

extension VisualListMapper on VisualList {
  VisualListEntity toEntity() {
    final entity = VisualListEntity(
      id: id ?? 0,
      userId: userId,
      name: name,
      steps: ToMany<UserCardEntity>(),
      isVisualSchedule: isVisualSchedule,
      isVisualDiagram: isVisualDiagram
    );

    entity.steps.addAll(steps.map((e) => e.toEntity()));

    return entity;
  }
}
