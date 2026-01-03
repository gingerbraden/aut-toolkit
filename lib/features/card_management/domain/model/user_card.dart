import '../../../../core/model/sync_entity.dart';

enum WordCategory {
  NOUN,
  PRONOUN,
  VERB,
  ADJECTIVE,
  PREPOSITION,
  QUESTION,
  NEGATION_IMPORTANT,
  ADVERB,
  CONJUNCTION,
  DETERMINER,
}

class UserCard {
  int? id;
  int? arasaacId;
  String userId;
  String localImgPath;
  Map<String, String> names;
  WordCategory? wordCategory;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;
  String? remoteImgPath;

  UserCard({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.names,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
    required this.remoteImgPath,
    this.wordCategory,
  });
}
