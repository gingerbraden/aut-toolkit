import 'package:aut_toolkit/core/model/sync_entity.dart';

class AACKeyboardRemoteEntity extends SyncEntity {
  int localId;
  String userId;
  String name;
  List<String> slots;
  bool isInternal;

  AACKeyboardRemoteEntity({
    required this.localId,
    required this.slots,
    required this.userId,
    required this.name,
    required super.updatedAt,
    required this.isInternal
  });
}
