import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/challenging_behaviour_diary_entry_remote_entity.dart';
import '../model/challenging_behaviour_remote_entity.dart';

class ChallengingBehaviourRemoteSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userBehavioursRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('challenging_behaviour');
  }

  ChallengingBehaviourRemoteSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRemote(ChallengingBehaviourRemoteEntity entity) async {
    final uid = entity.userId;

    final docRef = entity.remoteId != null
        ? _userBehavioursRef(uid).doc(entity.remoteId)
        : _userBehavioursRef(uid).doc();

    await docRef.set(_entityToMap(entity));

    return docRef.id;
  }

  Future<void> updateRemote(ChallengingBehaviourRemoteEntity entity) async {
    if (entity.remoteId == null) {
      throw ArgumentError('remoteId is null');
    }

    await _userBehavioursRef(
      entity.userId,
    ).doc(entity.remoteId).update(_entityToMap(entity));
  }

  Future<void> deleteRemote(ChallengingBehaviourEntity entity) async {
    if (entity.remoteId == null) return;

    await _userBehavioursRef(entity.userId).doc(entity.remoteId).delete();
  }

  Future<List<ChallengingBehaviourRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final snapshot = await _userBehavioursRef(userId).get();

      return snapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote challenging behaviours: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(ChallengingBehaviourRemoteEntity e) {
    return {
      'id': e.localId,
      'name': e.name,
      'from': e.from.toIso8601String(),
      'generalDescription': e.generalDescription,
      'diaryEntries': e.diaryEntries.map(
        (x) => challengingBehaviourDiaryEntryRemoteEntityToMap(x),
      ),
      'occuring': e.occuring,
      'userId': e.userId,
      'selectedPersonId': e.selectedPersonId,
      'updatedAt': e.updatedAt.toIso8601String(),
      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
    };
  }

  Map<String, dynamic> challengingBehaviourDiaryEntryRemoteEntityToMap(
    ChallengingBehaviourDiaryEntryRemoteEntity e,
  ) {
    return {
      'id': e.id,
      'location': e.location,
      'date': e.date.toIso8601String(),
      'duration': e.duration,
      'circumstances': e.circumstances,
      'people': e.people,
      'outcome': e.outcome,
      'reflection': e.reflection,
    };
  }

  ChallengingBehaviourRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    final diaryEntries = (d['diaryEntries'] as List<dynamic>? ?? [])
        .map((x) => challengingBehaviourDiaryEntryRemoteEntityFromMap(x))
        .toList();

    return ChallengingBehaviourRemoteEntity(
        localId: d['id'] ?? 0,
        name: d['name'] ?? '',
        from: DateTime.parse(d['from']),
        generalDescription: d['generalDescription'] ?? '',
        diaryEntries: diaryEntries,
        occuring: d['occuring'] ?? false,
        userId: d['userId'] ?? '',
        selectedPersonId: d['selectedPersonId'] ?? '',
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
      )
      ..remoteId = snap.id
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }

  ChallengingBehaviourDiaryEntryRemoteEntity
  challengingBehaviourDiaryEntryRemoteEntityFromMap(Map<String, dynamic> d) {
    return ChallengingBehaviourDiaryEntryRemoteEntity(
      id: d['id'] ?? 0,
      location: d['location'] ?? '',
      date: DateTime.parse(d['date']),
      duration: d['duration'] ?? 0,
      circumstances: d['circumstances'] ?? '',
      people: List<String>.from(d['people'] ?? []),
      outcome: d['outcome'] ?? '',
      reflection: d['reflection'] ?? '',
    );
  }
}
