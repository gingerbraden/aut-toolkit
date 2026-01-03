import 'package:objectbox/objectbox.dart';

@Entity()
class UserCardEntity {
  @Id()
  int id = 0;
  int? arasaacId;
  String userId;
  String localImgPath;
  String namesJson;
  int? wordCategory;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;
  String? remoteImgPath;

  UserCardEntity({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.namesJson,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
    required this.remoteImgPath,
    this.wordCategory,
  });
}
