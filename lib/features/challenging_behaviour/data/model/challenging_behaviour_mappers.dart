import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

extension ChallengingBehaviourMapper on ChallengingBehaviourEntity {
  ChallengingBehaviour toModel() {
    return ChallengingBehaviour(
      id: id,
      name: name,
      from: from,
      description: generalDescription,
      occuring: occuring,
      diaryEntries: diaryEntries.map((e) => e.toModel()).toList(),
      userId: userId
    );
  }
}

extension ChallengingBehaviourEntityMapper on ChallengingBehaviour {
  ChallengingBehaviourEntity toEntity() {
    final entity = ChallengingBehaviourEntity(
      id: id,
      name: name,
      from: from,
      generalDescription: description,
      occuring: occuring,
      diaryEntries: ToMany<ChallengingBehaviourDiaryEntryEntity>(),
      userId: userId
    );

    if (diaryEntries.isNotEmpty) {
      entity.diaryEntries.addAll(
        diaryEntries.map((e) => e.toEntity()).toList(),
      );
    }

    return entity;
  }
}

extension ChallengingBehaviourDiaryEntryMapper on ChallengingBehaviourDiaryEntryEntity {
  ChallengingBehaviourDiaryEntry toModel() {
    return ChallengingBehaviourDiaryEntry(
      id: id,
      location: location,
      date: date,
      duration: duration,
      circumstances: circumstances,
      people: people,
      outcome: outcome,
      reflection: reflection,
    );
  }
}

extension ChallengingBehaviourDiaryEntryEntityMapper on ChallengingBehaviourDiaryEntry {
  ChallengingBehaviourDiaryEntryEntity toEntity() {
    return ChallengingBehaviourDiaryEntryEntity(
      id: id,
      location: location,
      date: date,
      duration: duration,
      circumstances: circumstances,
      people: people,
      outcome: outcome,
      reflection: reflection,
    );
  }
}
