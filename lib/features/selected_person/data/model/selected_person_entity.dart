import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';

@Entity()
class SelectedPersonEntity {
  @Id()
  int id = 0;
  bool isSelected;
  String userId;
  String name;

  @Index()
  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  SelectedPersonEntity({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.isSelected,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
    this.remoteId
  });

}

extension CardBoxExtensions on Box<SelectedPersonEntity> {
  SelectedPersonEntity? getByRemoteId(String remoteId) {
    return query(SelectedPersonEntity_.remoteId.equals(remoteId))
        .build()
        .findFirst();
  }
}
