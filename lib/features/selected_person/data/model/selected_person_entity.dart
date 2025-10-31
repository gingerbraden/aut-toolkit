import 'package:objectbox/objectbox.dart';

@Entity()
class SelectedPersonEntity {
  @Id()
  int id = 0;
  bool isSelected;
  String userId;
  String name;

  SelectedPersonEntity({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.isSelected
  });

}
