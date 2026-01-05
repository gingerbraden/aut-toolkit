import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';
import '../model/selected_person_entity.dart';

class SelectedPersonLocalSource {
  final Box<SelectedPersonEntity> selectedPersonBox;

  SelectedPersonLocalSource(this.selectedPersonBox);

  List<SelectedPersonEntity> getAll() => selectedPersonBox.getAll();

  int put(SelectedPersonEntity entity) => selectedPersonBox.put(entity);

  void remove(int id) => selectedPersonBox.remove(id);

  SelectedPersonEntity? getById(int id) => selectedPersonBox.get(id);

  List<SelectedPersonEntity> getAllPending() {
    final q = selectedPersonBox.query(
      SelectedPersonEntity_.pendingAction.notEquals(0),
    ).build();
    final result = q.find();
    q.close();
    return result;
  }

  Stream<List<SelectedPersonEntity>> watchAll() {
    final builder = selectedPersonBox.query();

    return builder
        .watch(triggerImmediately: true)
        .map((query) {
      final result = query.find();
      return result;
    });
  }
}
