class ChallengingBehaviourDiaryEntry {
  int? id;

  // where did the behaviour occur
  String location;

  // when did the behaviour occur
  DateTime date;

  // how long did the behaviour last (minutes)
  int duration;

  // what happened before
  String circumstances;

  // who was there
  List<String> people;

  // what was the outcome
  String outcome;

  // why it maybe happened?
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
