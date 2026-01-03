import 'package:aut_toolkit/core/model/sync_entity.dart';

class UserCardRemoteEntity extends SyncEntity {
  int localId;
  int? arasaacId;
  String userId;
  String localImgPath;
  String namesJson;
  String? remoteImagePath;

  UserCardRemoteEntity({
    required this.localId,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.namesJson,
    required super.updatedAt,
    required this.remoteImagePath,
  });
}
