import 'package:objectbox/objectbox.dart';

@Entity()
class CardEntity {
  @Id()
  int id = 0;
  int? arasaacId;
  String userId;
  String localImgPath;
  String namesJson;

  CardEntity({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.namesJson,
  });
}
