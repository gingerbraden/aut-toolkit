import '../model/selected_person.dart';

abstract class SelectedPersonRepository {
  List<SelectedPerson> getAll();
  void save(SelectedPerson eatingHabit);
  void delete(SelectedPerson eatingHabit);
}
