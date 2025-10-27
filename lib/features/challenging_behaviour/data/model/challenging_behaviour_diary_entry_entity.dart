import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ChallengingBehaviourDiaryEntryEntity {

  @Id()
  int? id;

  final ToOne<ChallengingBehaviourEntity> challengingBehaviour = ToOne<ChallengingBehaviourEntity>();

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

  ChallengingBehaviourDiaryEntryEntity({
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
