import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:objectbox/objectbox.dart';

class ChallengingBehaviourDiaryEntryRemoteEntity {

  int? id;

  final ToOne<ChallengingBehaviourEntity> challengingBehaviour = ToOne<ChallengingBehaviourEntity>();

  String location;

  DateTime date;

  int duration;

  String circumstances;

  List<String> people;

  String outcome;

  String reflection;

  ChallengingBehaviourDiaryEntryRemoteEntity({
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
