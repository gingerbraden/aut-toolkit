import 'dart:async';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
import '../data/model/user_card_entity.dart';
import '../data/source/card_local_source.dart';
import '../data/source/card_remote_source.dart';
import '../domain/model/user_card.dart';
import '../domain/repository/card_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final cardBoxProvider = Provider<Box<UserCardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.cardBox;
});

final cardRemoteSourceProvider = Provider<CardRemoteSource>((ref) {
  return CardRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final cardLocalSourceProvider = Provider<CardLocalSource>((ref) {
  final box = ref.watch(cardBoxProvider);
  return CardLocalSource(box);
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return RepoService().cardRepositoryImpl;
});

final cardsProvider = StateNotifierProvider<CardsNotifier, List<UserCard>>((
  ref,
) {
  final repo = ref.watch(cardRepositoryProvider);
  return CardsNotifier(repo);
});

class CardsNotifier extends StateNotifier<List<UserCard>> {
  final CardRepository _repo;
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  CardsNotifier(this._repo) : super([]) {
    _sub = _repo.watchAll().listen((data) {
      state = data;
    });
  }

  void loadCards() {
    state = _repo.getAllCards();
  }

  void addCard(UserCard card) {
    _repo.saveCard(card);
  }

  void deleteCard(UserCard card) {
    _repo.deleteCard(card);
  }
}
