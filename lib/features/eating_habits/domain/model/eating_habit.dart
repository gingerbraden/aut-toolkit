class EatingHabit {
  int? id;
  DateTime from;
  DateTime? to;
  bool isEatingFlag;
  String name;
  String description;

  EatingHabit({
    this.id = 0,
    required this.from,
    required this.to,
    required this.isEatingFlag,
    required this.name,
    required this.description,
  });
}
