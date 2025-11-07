import 'package:objectbox/objectbox.dart';

@Entity()
class UserCardEntity {
  @Id()
  int id = 0;
  int? arasaacId;
  String userId;
  String localImgPath;
  String namesJson;

  UserCardEntity({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.namesJson,
  });
}
