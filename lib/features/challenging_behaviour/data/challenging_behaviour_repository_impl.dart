import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_mappers.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/repository/challenging_behaviour_repository.dart';

class ChallengingBehaviourRepositoryImpl implements ChallengingBehaviourRepository {
  final ChallengingBehaviourLocalSource _localSource;

  ChallengingBehaviourRepositoryImpl(this._localSource);

  @override
  List<ChallengingBehaviour> getAllCb() {
    return _localSource
        .getAllBehaviours()
        .map((entity) => entity.toModel())
        .toList();
  }

  @override
  void saveCb(ChallengingBehaviour cb) {
    _localSource.putBehaviour(cb.toEntity());
  }

  @override
  void deleteCb(ChallengingBehaviour cb) {
    if (cb.id != null) {
      _localSource.deleteBehaviour(cb.id!);
    }
  }

  @override
  void addDe(
      int cbId, ChallengingBehaviourDiaryEntry cbed) {
    _localSource.addDiaryEntry(cbId, cbed.toEntity());
  }

  @override
  void deleteDe(ChallengingBehaviourDiaryEntry cbed) {
    if (cbed.id != null) {
      _localSource.deleteDiaryEntry(cbed.id!);
    }
  }

  @override
  List<ChallengingBehaviourDiaryEntry> getAllDe(int cbId) {
    final entries = _localSource.getDiaryEntries(behaviourId: cbId);
    return entries.map((e) => e.toModel()).toList();
  }

}
