import 'dart:io';

import 'package:aut_toolkit/features/card_management/data/model/user_card_remote_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/user_card_entity.dart';

class CardRemoteSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String collectionPath = 'user_cards';

  CardRemoteSource({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, String folder, String filename) async {
    final ref = _storage.ref().child('$folder/$filename');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> createRemote(UserCardRemoteEntity entity, {File? file}) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(collectionPath).doc(entity.remoteId)
        : _firestore.collection(collectionPath).doc();

    await docRef.set(_entityToMap(entity));
    return docRef.id;
  }

  Future<void> deleteRemoteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      print("Error deleting image: ${e.code}");
    }
  }

  Future<void> updateRemote(UserCardRemoteEntity entity, {File? file}) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');

    final docRef = _firestore
        .collection(collectionPath)
        .doc(entity.remoteId.toString());

    if (((entity.localImgPath.isEmpty)) &&
        entity.remoteImagePath != null &&
        entity.remoteImagePath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImagePath!);
    }

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(UserCardEntity entity) async {
    if (entity.remoteId == null) return;

    final docRef = _firestore
        .collection(collectionPath)
        .doc(entity.remoteId.toString());

    await docRef.delete();

    if (entity.remoteImgPath != null && entity.remoteImgPath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImgPath!);
    }
  }

  Future<List<UserCardRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote user cards: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(UserCardRemoteEntity e) {
    return {
      'localId': e.localId,
      'arasaacId': e.arasaacId,
      'userId': e.userId,
      'localImgPath': e.localImgPath,
      'namesJson': e.namesJson,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
      'remoteImgPath': e.remoteImagePath,
    };
  }

  UserCardRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    return UserCardRemoteEntity(
        localId: d['localId'] ?? 0,
        arasaacId: d['arasaacId'] ?? 0,
        userId: d['userId'] ?? '',
        localImgPath: d['localImgPath'] ?? '',
        namesJson: d['namesJson'] ?? '',
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
        remoteImagePath: d['remoteImgPath'] ?? null,
      )
      ..remoteId = snap.id
      ..isSynced = d['isSynced'] ?? true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
