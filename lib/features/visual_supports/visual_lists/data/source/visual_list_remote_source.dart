import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/model/sync_entity.dart';
import '../model/visual_list_remote_entity.dart';

class VisualListRemoteSource {
  final FirebaseFirestore _firestore;
  final String collectionPath = 'visual_lists';

  VisualListRemoteSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRemote(VisualListRemoteEntity entity) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(collectionPath).doc(entity.remoteId)
        : _firestore.collection(collectionPath).doc();

    await docRef.set(_entityToMap(entity));
    return docRef.id;
  }

  Future<void> updateRemote(VisualListRemoteEntity entity) async {
    if (entity.remoteId == null) {
      throw ArgumentError('remoteId is null');
    }

    final docRef =
    _firestore.collection(collectionPath).doc(entity.remoteId.toString());

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(VisualListRemoteEntity entity) async {
    if (entity.remoteId == null) return;

    final docRef =
    _firestore.collection(collectionPath).doc(entity.remoteId.toString());

    await docRef.delete();
  }

  Future<List<VisualListRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => mapFromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching remote visual lists: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(VisualListRemoteEntity e) {
    return {
      'localId': e.localId,
      'userId': e.userId,
      'steps': e.steps,
      'name': e.name,
      'isVisualSchedule': e.isVisualSchedule,
      'isVisualDiagram': e.isVisualDiagram,
      'stepsOrderJson': e.stepsOrderJson,
      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
    };
  }

  VisualListRemoteEntity mapFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snap,
      ) {
    final d = snap.data() ?? {};

    return VisualListRemoteEntity(
      localId: d['localId'] ?? 0,
      userId: d['userId'] ?? '',
      name: d['name'] ?? '',
      isVisualSchedule: d['isVisualSchedule'] ?? false,
      isVisualDiagram: d['isVisualDiagram'] ?? false,
      stepsOrderJson: d['stepsOrderJson'],
      updatedAt: d['updatedAt'] != null
          ? DateTime.parse(d['updatedAt'])
          : DateTime.now(),
      steps: (d['steps'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
    )
      ..remoteId = snap.id
      ..isSynced = d['isSynced'] ?? true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
