import 'dart:convert';

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

  factory ChallengingBehaviourDiaryEntry.fromJsonMap(
    Map<String, dynamic> json,
  ) {
    return ChallengingBehaviourDiaryEntry(
      id: json['id'] ?? 0,
      location: json['l'] ?? '',
      date: DateTime.parse(json['d']),
      duration: json['du'] ?? 0,
      circumstances: json['c'] ?? '',
      people:
          (json['p'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      outcome: json['o'] ?? '',
      reflection: json['r'] ?? '',
    );
  }

  factory ChallengingBehaviourDiaryEntry.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return ChallengingBehaviourDiaryEntry.fromJsonMap(jsonMap);
  }
}

extension ChallengingBehaviourDiaryEntryExtensions
    on ChallengingBehaviourDiaryEntry {
  String toJson() {
    return jsonEncode({
      'd': date.toIso8601String(),
      'l': location,
      'du': duration,
      'c': circumstances,
      'p': people,
      'o': outcome,
      'r': reflection,
    });
  }
}
