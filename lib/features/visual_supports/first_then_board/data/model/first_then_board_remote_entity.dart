import 'package:aut_toolkit/core/model/sync_entity.dart';

class FirstThenBoardRemoteEntity extends SyncEntity {
  int localId = 0;
  String userId;
  int first;
  int then;
  String name;

  FirstThenBoardRemoteEntity({
    this.localId = 0,
    required this.userId,
    required this.first,
    required this.then,
    required this.name,
    required super.updatedAt
  });
}
