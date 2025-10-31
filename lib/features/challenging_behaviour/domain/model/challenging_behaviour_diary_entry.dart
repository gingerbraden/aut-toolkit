class ChallengingBehaviourDiaryEntry {
  int? id;

  String location;

  DateTime date;

  int duration;

  String circumstances;

  List<String> people;

  String outcome;

  String reflection;

  ChallengingBehaviourDiaryEntry({
    this.id = 0,
    required this.location,
    required this.date,
    required this.duration,
    required this.circumstances,
    required this.people,
    required this.outcome,
    required this.reflection,
  });
}
