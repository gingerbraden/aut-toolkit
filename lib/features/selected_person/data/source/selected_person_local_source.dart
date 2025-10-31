import 'package:objectbox/objectbox.dart';

import '../model/selected_person_entity.dart';

class SelectedPersonLocalSource {
  final Box<SelectedPersonEntity> selectedPersonBox;

  SelectedPersonLocalSource(this.selectedPersonBox);

  List<SelectedPersonEntity> getAll() => selectedPersonBox.getAll();

  int put(SelectedPersonEntity entity) => selectedPersonBox.put(entity);

  void remove(int id) => selectedPersonBox.remove(id);
}
