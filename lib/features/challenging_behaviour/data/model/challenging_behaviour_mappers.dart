import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

import '../../../../core/model/sync_entity.dart';
import 'challenging_behaviour_diary_entry_remote_entity.dart';
import 'challenging_behaviour_remote_entity.dart';

extension ChallengingBehaviourMapper on ChallengingBehaviourEntity {
  ChallengingBehaviour toModel() {
    return ChallengingBehaviour(
      id: id,
      name: name,
      from: from,
      description: generalDescription,
      occuring: occuring,
      diaryEntries: diaryEntries.map((e) => e.toModel()).toList(),
      userId: userId,
      selectedPersonId: selectedPersonId,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId
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
      userId: userId,
      selectedPersonId: selectedPersonId,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: pendingAction.index,
      remoteId: remoteId
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


extension ChallengingBehaviourEntityToRemote on ChallengingBehaviourEntity {
  ChallengingBehaviourRemoteEntity toRemote() => ChallengingBehaviourRemoteEntity(
    localId: id!,
    name: name,
    from: from,
    generalDescription: generalDescription,
    diaryEntries: diaryEntries.map((x) => x.toRemote()).toList(),
    occuring: occuring,
    userId: userId,
    selectedPersonId: selectedPersonId,
    updatedAt: updatedAt,
  )
    ..isDeleted = isDeleted
    ..isSynced = true
    ..pendingAction = PendingAction.NONE
    ..remoteId = remoteId;
}

extension ChallengingBehaviourRemoteToEntity on ChallengingBehaviourRemoteEntity {
  ChallengingBehaviourEntity toEntity() => ChallengingBehaviourEntity(
    id: localId,
    name: name,
    from: from,
    generalDescription: generalDescription,
    diaryEntries: ToMany<ChallengingBehaviourDiaryEntryEntity>()..addAll(diaryEntries.map((x) => x.toEntity()).toList()),
    occuring: occuring,
    userId: userId,
    selectedPersonId: selectedPersonId,
    remoteId: remoteId,
    updatedAt: updatedAt,
    isSynced: isSynced,
    isDeleted: isDeleted,
    pendingAction: pendingAction.index,
  );
}

extension DiaryEntryEntityToRemote on ChallengingBehaviourDiaryEntryEntity {
  ChallengingBehaviourDiaryEntryRemoteEntity toRemote() => ChallengingBehaviourDiaryEntryRemoteEntity(
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

extension DiaryEntryRemoteToEntity on ChallengingBehaviourDiaryEntryRemoteEntity {
  ChallengingBehaviourDiaryEntryEntity toEntity() => ChallengingBehaviourDiaryEntryEntity(
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
