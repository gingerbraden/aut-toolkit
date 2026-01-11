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
import 'package:aut_toolkit/features/selected_person/data/selected_person_repository_impl.dart';
import 'package:aut_toolkit/features/selected_person/data/source/selected_person_local_source.dart';
import 'package:aut_toolkit/features/selected_person/data/source/selected_person_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/first_then_board_repository_impl.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/visual_list_repository_impl.dart';
import 'package:aut_toolkit/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  late final SelectedPersonRepositoryImpl selectedPersonRepositoryImpl;
  late final FirstThenBoardRepositoryImpl firstThenBoardRepositoryImpl;
  late final VisualListRepositoryImpl visualListRepositoryImpl;

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

    selectedPersonRepositoryImpl = SelectedPersonRepositoryImpl(
      SelectedPersonLocalSource(objectbox.selectedPersonBox),
      ChallengingBehaviourLocalSource(
        objectbox.challengingBehaviourBox,
        objectbox.challengingBehaviourDiaryEntryBox,
      ),
      EatingHabitLocalSource(objectbox.eatingHabitEntityBox),
      GoodHabitLocalSource(objectbox.goodHabitBox),
      SelectedPersonRemoteSource(),
      syncManager,
    );

    firstThenBoardRepositoryImpl = FirstThenBoardRepositoryImpl(
      FirstThenBoardLocalSource(objectbox.firstThenBoardBox),
      FirstThenBoardRemoteSource(),
      syncManager,
    );

    visualListRepositoryImpl = VisualListRepositoryImpl(
      VisualListLocalSource(objectbox.visualListBox),
      VisualListRemoteSource(),
      syncManager,
    );

    syncManager.start();
  }

  Future<void> fetchAllRemoteData() async {
    final conn = Connectivity();
    var result = await conn.checkConnectivity();
    if (!result.contains(ConnectivityResult.wifi) && !result.contains(ConnectivityResult.mobile)) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // await goodHabitRepository.fetchRemote();
    // await challengingBehaviourRepository.fetchRemote();
    // await eatingHabitRepository.fetchRemote();
    await cardRepositoryImpl.fetchRemote();
    // await selectedPersonRepositoryImpl.fetchRemote();
    await firstThenBoardRepositoryImpl.fetchRemote();
    await visualListRepositoryImpl.fetchRemote();
  }
}
