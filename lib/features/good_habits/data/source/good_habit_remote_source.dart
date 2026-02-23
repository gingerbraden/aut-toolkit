import 'package:aut_toolkit/features/good_habits/data/model/good_habit_remote_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/good_habit_entity.dart';

class GoodHabitRemoteSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userHabitsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('good_habits');
  }

  GoodHabitRemoteSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRemote(GoodHabitRemoteEntity entity) async {
    final uid = entity.userId;

    final docRef = entity.remoteId != null
        ? _userHabitsRef(uid).doc(entity.remoteId)
        : _userHabitsRef(uid).doc();

    await docRef.set(_entityToMap(entity));

    return docRef.id;
  }

  Future<void> updateRemote(GoodHabitRemoteEntity entity) async {
    if (entity.remoteId == null) {
      throw ArgumentError('remoteId is null');
    }

    final docRef = _userHabitsRef(entity.userId).doc(entity.remoteId);

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(GoodHabitEntity entity) async {
    if (entity.remoteId == null) return;

    await _userHabitsRef(entity.userId).doc(entity.remoteId).delete();
  }

  Future<List<GoodHabitRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final snapshot = await _userHabitsRef(userId).get();

      return snapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote habits: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(GoodHabitRemoteEntity e) {
    return {
      'localId': e.localId,
      'from': e.from.toIso8601String(),
      'to': e.to?.toIso8601String(),
      'userId': e.userId,
      'name': e.name,
      'description': e.description,
      'isOccuringFlag': e.isOccuringFlag,
      'selectedPersonId': e.selectedPersonId,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
    };
  }

  GoodHabitRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    return GoodHabitRemoteEntity(
        localId: d['localId'] ?? 0,
        from: DateTime.parse(d['from']),
        to: d['to'] != null ? DateTime.parse(d['to']) : null,
        userId: d['userId'] ?? '',
        name: d['name'] ?? '',
        description: d['description'] ?? '',
        isOccuringFlag: d['isOccuringFlag'] ?? false,
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
}
