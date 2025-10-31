import 'package:objectbox/objectbox.dart';

@Entity()
class GoodHabitEntity {
  @Id()
  int id = 0;

  DateTime from;
  String userId;
  String name;
  String description;
  bool isOccuringFlag;
  int selectedPersonId;

  GoodHabitEntity({
    this.id = 0,
    required this.from,
    required this.userId,
    required this.name,
    required this.description,
    required this.isOccuringFlag,
    required this.selectedPersonId
  });

}
