import 'dart:io';

import 'package:aut_toolkit/features/card_management/data/model/user_card_remote_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/user_card_entity.dart';

class CardRemoteSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> _userCardsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('cards_images');
  }

  CardRemoteSource({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, String uid, String filename) async {
    final ref = _storage.ref().child(
      'users/$uid/cards_images/$filename',
    );
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> createRemote(UserCardRemoteEntity entity) async {
    final uid = entity.userId;

    final docRef = entity.remoteId != null
        ? _userCardsRef(uid).doc(entity.remoteId)
        : _userCardsRef(uid).doc();

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

  Future<void> updateRemote(UserCardRemoteEntity entity) async {
    if (entity.remoteId == null) {
      throw ArgumentError('remoteId is null');
    }

    final docRef = _userCardsRef(entity.userId).doc(entity.remoteId);

    if (entity.localImgPath.isEmpty &&
        entity.remoteImagePath != null &&
        entity.remoteImagePath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImagePath!);
    }

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(UserCardEntity entity) async {
    if (entity.remoteId == null) return;

    final uid = entity.userId;

    await _userCardsRef(uid).doc(entity.remoteId).delete();

    if (entity.remoteImgPath != null && entity.remoteImgPath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImgPath!);
    }
  }

  Future<List<UserCardRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final snapshot = await _userCardsRef(userId).get();

      return snapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote user cards: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(UserCardRemoteEntity e) {
    return {
      'arasaacId': e.arasaacId,
      'userId': e.userId,
      'localImgPath': e.localImgPath,
      'namesJson': e.namesJson,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
      'remoteImgPath': e.remoteImagePath,
      'wordCategory': e.wordCategory,
    };
  }

  UserCardRemoteEntity mapFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    return UserCardRemoteEntity(
        arasaacId: d['arasaacId'] ?? 0,
        userId: d['userId'] ?? '',
        localImgPath: d['localImgPath'] ?? '',
        namesJson: d['namesJson'] ?? '',
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
        remoteImagePath: d['remoteImgPath'] ?? null,
        wordCategory: d['wordCategory'] ?? 0,
      )
      ..remoteId = snap.id
      ..isSynced = d['isSynced'] ?? true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
