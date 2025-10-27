import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';

abstract class ChallengingBehaviourRepository {
  List<ChallengingBehaviour> getAllCb();
  void saveCb(ChallengingBehaviour cb);
  void deleteCb(ChallengingBehaviour cb);

  void addDe(int cbId, ChallengingBehaviourDiaryEntry cbed);
  void deleteDe(ChallengingBehaviourDiaryEntry cbed);
  List<ChallengingBehaviourDiaryEntry> getAllDe(int cbId);
}