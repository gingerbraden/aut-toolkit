import 'package:aut_toolkit/core/model/sync_entity.dart';

class FirstThenBoardRemoteEntity extends SyncEntity {
  int localId;
  String userId;
  String first;
  String then;
  String name;

  FirstThenBoardRemoteEntity({
    required this.localId,
    required this.userId,
    required this.first,
    required this.then,
    required this.name,
    required super.updatedAt
  });
}
