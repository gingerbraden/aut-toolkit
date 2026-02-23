import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/model/sync_entity.dart';
import '../model/first_then_board_remote_entity.dart';

class FirstThenBoardRemoteSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userBoardsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('first_then_boards');
  }

  FirstThenBoardRemoteSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRemote(FirstThenBoardRemoteEntity entity) async {
    final uid = entity.userId;
    final docRef = entity.remoteId != null
        ? _userBoardsRef(uid).doc(entity.remoteId)
        : _userBoardsRef(uid).doc();

    await docRef.set(_entityToMap(entity));
    return docRef.id;
  }

  Future<void> updateRemote(FirstThenBoardRemoteEntity entity) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');

    final docRef = _userBoardsRef(entity.userId).doc(entity.remoteId);
    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(FirstThenBoardRemoteEntity entity) async {
    if (entity.remoteId == null) return;

    final docRef = _userBoardsRef(entity.userId).doc(entity.remoteId);
    await docRef.delete();
  }

  Future<List<FirstThenBoardRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final snapshot = await _userBoardsRef(userId).get();
      return snapshot.docs.map(mapFromSnapshot).toList();
    } catch (e) {
      print('Error fetching remote first-then boards: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(FirstThenBoardRemoteEntity e) {
    return {
      'localId': e.localId,
      'userId': e.userId,
      'first': e.first,
      'then': e.then,
      'name': e.name,
      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
    };
  }

  FirstThenBoardRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    return FirstThenBoardRemoteEntity(
        localId: d['localId'] ?? 0,
        userId: d['userId'] ?? '',
        first: d['first'] ?? 0,
        then: d['then'] ?? 0,
        name: d['name'] ?? '',
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
      )
      ..remoteId = snap.id
      ..isSynced = d['isSynced'] ?? true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
