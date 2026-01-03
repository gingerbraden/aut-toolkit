import 'package:aut_toolkit/core/services/sync_manager.dart';
import 'package:aut_toolkit/features/card_management/data/card_repository_impl.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_local_source.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_remote_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/challenging_behaviour_repository_impl.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_remote_source.dart';
import 'package:aut_toolkit/features/eating_habits/data/eating_habit_repository_impl.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_remote_source.dart';
import 'package:aut_toolkit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/good_habits/data/good_habit_repository_impl.dart';
import '../../features/good_habits/data/source/good_habit_local_source.dart';
import '../../features/good_habits/data/source/good_habit_remote_source.dart';

class RepoService {
  late final SyncManager syncManager;
  late final GoodHabitRepositoryImpl goodHabitRepository;
  late final ChallengingBehaviourRepositoryImpl challengingBehaviourRepository;
  late final EatingHabitRepositoryImpl eatingHabitRepository;
  late final CardRepositoryImpl cardRepositoryImpl;

  static final RepoService _instance = RepoService._();

  factory RepoService() => _instance;

  RepoService._();

  Future<void> init() async {
    syncManager = SyncManager();
    goodHabitRepository = GoodHabitRepositoryImpl(
      GoodHabitLocalSource(objectbox.goodHabitBox),
      GoodHabitRemoteSource(),
      syncManager,
    );

    challengingBehaviourRepository = ChallengingBehaviourRepositoryImpl(
      ChallengingBehaviourLocalSource(
        objectbox.challengingBehaviourBox,
        objectbox.challengingBehaviourDiaryEntryBox,
      ),
      ChallengingBehaviourRemoteSource(),
      syncManager,
    );

    eatingHabitRepository = EatingHabitRepositoryImpl(
      EatingHabitLocalSource(objectbox.eatingHabitEntityBox),
      EatingHabitRemoteSource(),
      syncManager,
    );

    cardRepositoryImpl = CardRepositoryImpl(
      CardLocalSource(objectbox.cardBox),
      CardRemoteSource(),
      syncManager,
    );

    await _fetchAllRemoteData();
    syncManager.start();
  }

  Future<void> _fetchAllRemoteData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await goodHabitRepository.fetchRemote();
    await challengingBehaviourRepository.fetchRemote();
    await eatingHabitRepository.fetchRemote();
    await cardRepositoryImpl.fetchRemote();
  }
}
