import 'package:aut_toolkit/core/model/sync_entity.dart';

class VisualListRemoteEntity extends SyncEntity {
  int localId;
  String userId;
  List<int> steps;
  String name;
  bool isVisualSchedule;
  bool isVisualDiagram;
  String? stepsOrderJson;

  VisualListRemoteEntity({
    required this.localId,
    required this.userId,
    required this.name,
    required this.isVisualSchedule,
    required this.isVisualDiagram,
    this.stepsOrderJson,
    required super.updatedAt,
    required this.steps,
  });
}
