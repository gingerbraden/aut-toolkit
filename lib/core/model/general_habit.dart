class GeneralHabit {
  int? id;
  DateTime from;
  String userId;
  String name;
  String description;

  GeneralHabit({
    this.id = 0,
    required this.from,
    required this.userId,
    required this.name,
    required this.description,
  });
}
