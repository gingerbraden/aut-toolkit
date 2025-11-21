import 'package:objectbox/objectbox.dart';

import '../../../../card_management/data/model/user_card_entity.dart';

@Entity()
class VisualListEntity {
  @Id()
  int id = 0;
  String userId;
  ToMany<UserCardEntity> steps;
  String name;
  bool isVisualSchedule;
  bool isVisualDiagram;

  VisualListEntity({
    this.id = 0,
    required this.userId,
    required this.steps,
    required this.name,
    required this.isVisualSchedule,
    required this.isVisualDiagram
  });
}
