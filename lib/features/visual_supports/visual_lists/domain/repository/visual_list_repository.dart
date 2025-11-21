import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/model/visual_list.dart';

abstract class VisualListRepository {
  List<VisualList> getAllVisualSchedulesForUserId(String userId);

  List<VisualList> getAllVisualDiagramsForUserId(String userId);

  void save(VisualList board);

  void delete(VisualList board);
}
