import 'package:objectbox/objectbox.dart';

import '../../../../../objectbox.g.dart';
import '../../../../card_management/data/model/user_card_entity.dart';

@Entity()
class VisualListEntity {
  @Id()
  int id = 0;
  String userId;
  final steps = ToMany<UserCardEntity>();
  String name;
  bool isVisualSchedule;
  bool isVisualDiagram;
  String? stepsOrderJson;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  VisualListEntity({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.isVisualSchedule,
    required this.isVisualDiagram,
    this.stepsOrderJson,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
  });
}

extension VisualListExtensions on Box<VisualListEntity> {
  VisualListEntity? getByRemoteId(String remoteId) {
    return query(VisualListEntity_.remoteId.equals(remoteId))
        .build()
        .findFirst();
  }
}
