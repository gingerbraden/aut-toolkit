import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_mappers.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/model/visual_list.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/repository/visual_list_repository.dart';

class VisualListRepositoryImpl implements VisualListRepository {
  final VisualListLocalSource _localSource;

  VisualListRepositoryImpl(this._localSource);

  @override
  List<VisualList> getAllVisualSchedulesForUserId(String userId) {
    return _localSource
        .getAllVisualSchedulesForUserId(userId)
        .map((e) => e.toModel())
        .toList();
  }

  @override
  List<VisualList> getAllVisualDiagramsForUserId(String userId) {
    return _localSource
        .getAllVisualDiagramsForUserId(userId)
        .map((e) => e.toModel())
        .toList();
  }

  @override
  void save(VisualList list) {
    _localSource.put(list.toEntity());
  }

  @override
  void delete(VisualList list) {
    _localSource.remove(list.id!);
  }
}
