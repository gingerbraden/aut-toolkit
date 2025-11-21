import '../../../../card_management/domain/model/user_card.dart';

class VisualList {
  int? id;
  String userId;
  List<UserCard> steps;
  String name;
  bool isVisualSchedule;
  bool isVisualDiagram;

  VisualList({
    this.id = 0,
    required this.userId,
    required this.steps,
    required this.name,
    required this.isVisualSchedule,
    required this.isVisualDiagram
  });
}
