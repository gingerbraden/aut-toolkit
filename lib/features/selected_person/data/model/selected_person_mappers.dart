import 'package:aut_toolkit/features/selected_person/data/model/selected_person_entity.dart';

import '../../domain/model/selected_person.dart';

extension UserEntityMapper on SelectedPersonEntity {
  SelectedPerson toModel() => SelectedPerson(
    id: id,
    name: name,
    userId: userId,
    isSelected: isSelected,
  );
}

extension UserModelMapper on SelectedPerson {
  SelectedPersonEntity toEntity() => SelectedPersonEntity(
    id: id ?? 0,
    name: name,
    userId: userId,
    isSelected: isSelected,
  );
}
