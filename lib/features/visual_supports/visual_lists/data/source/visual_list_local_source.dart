import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

class VisualListLocalSource {
  final Box<VisualListEntity> visualListBox;

  VisualListLocalSource(this.visualListBox);

  List<VisualListEntity> getAllVisualSchedulesForUserId(String userId) {
    Query<VisualListEntity> q = visualListBox
        .query(
          VisualListEntity_.userId
              .equals(userId)
              .and(VisualListEntity_.isVisualSchedule.equals(true)),
        )
        .build();
    List<VisualListEntity> l = q.find();
    return l;
  }

  List<VisualListEntity> getAllVisualDiagramsForUserId(String userId) {
    Query<VisualListEntity> q = visualListBox
        .query(
          VisualListEntity_.userId
              .equals(userId)
              .and(VisualListEntity_.isVisualDiagram.equals(true)),
        )
        .build();
    List<VisualListEntity> l = q.find();
    return l;
  }

  List<VisualListEntity> getAll(String userId) {
    Query<VisualListEntity> q = visualListBox
        .query(
      VisualListEntity_.userId
          .equals(userId),
    )
        .build();
    List<VisualListEntity> l = q.find();
    return l;
  }

  int put(VisualListEntity entity) {
    if (entity.id != 0) {
      final oldEntity = visualListBox.get(entity.id);
      if (oldEntity != null) {
        oldEntity.steps.clear();
        visualListBox.put(oldEntity);
      }
    }

    return visualListBox.put(entity);
  }

  void remove(int id) => visualListBox.remove(id);

  VisualListEntity? getById(int id) => visualListBox.get(id);

  Stream<List<VisualListEntity>> watchAll() {
    final builder = visualListBox.query();

    return builder.watch(triggerImmediately: true).map((query) {
      final result = query.find();
      return result;
    });
  }

  List<VisualListEntity> getAllPending() {
    final q = visualListBox.query(VisualListEntity_.pendingAction.notEquals(0)).build();
    final result = q.find();
    q.close();
    return result;
  }
}
