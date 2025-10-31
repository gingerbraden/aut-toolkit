import 'package:aut_toolkit/core/model/general_habit.dart';

class EatingHabit extends GeneralHabit {
  DateTime? to;
  bool isEatingFlag;

  EatingHabit({
    super.id,
    required super.from,
    required super.userId,
    required this.to,
    required this.isEatingFlag,
    required super.name,
    required super.description,
    required super.selectedPersonId,
  });
}
