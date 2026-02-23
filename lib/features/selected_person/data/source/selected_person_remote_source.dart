import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/selected_person_entity.dart';
import '../model/selected_person_remote_entity.dart';

class SelectedPersonRemoteSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userSelectedPersonsRef(
    String uid,
  ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('selected_persons');
  }

  SelectedPersonRemoteSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRemote(SelectedPersonRemoteEntity entity) async {
    final uid = entity.userId;

    final docRef = entity.remoteId != null
        ? _userSelectedPersonsRef(uid).doc(entity.remoteId)
        : _userSelectedPersonsRef(uid).doc();

    await docRef.set(_entityToMap(entity));

    return docRef.id;
  }

  Future<void> updateRemote(SelectedPersonRemoteEntity entity) async {
    if (entity.remoteId == null) {
      throw ArgumentError('remoteId is null');
    }

    final docRef = _userSelectedPersonsRef(entity.userId).doc(entity.remoteId);

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(SelectedPersonEntity entity) async {
    if (entity.remoteId == null) return;

    await _userSelectedPersonsRef(entity.userId).doc(entity.remoteId).delete();
  }

  Future<List<SelectedPersonRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final snapshot = await _userSelectedPersonsRef(userId).get();

      return snapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote selected persons: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(SelectedPersonRemoteEntity e) {
    return {
      'localId': e.localId,
      'userId': e.userId,
      'name': e.name,
      'isSelected': e.isSelected,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
    };
  }

  SelectedPersonRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    return SelectedPersonRemoteEntity(
        localId: d['localId'] ?? 0,
        userId: d['userId'] ?? '',
        name: d['name'] ?? '',
        isSelected: d['isSelected'] ?? false,
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
