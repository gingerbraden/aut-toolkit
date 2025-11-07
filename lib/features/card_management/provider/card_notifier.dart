import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../main.dart';
import '../data/card_repository_impl.dart';
import '../data/model/user_card_entity.dart';
import '../data/source/card_local_source.dart';
import '../domain/model/user_card.dart';
import '../domain/repository/card_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final cardBoxProvider = Provider<Box<UserCardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.cardBox;
});

final cardLocalSourceProvider = Provider<CardLocalSource>((ref) {
  final box = ref.watch(cardBoxProvider);
  return CardLocalSource(box);
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final localSource = ref.watch(cardLocalSourceProvider);
  return CardRepositoryImpl(localSource);
});

final cardsProvider =
    StateNotifierProvider<CardsNotifier, List<UserCard>>((ref) {
      final repo = ref.watch(cardRepositoryProvider);
      return CardsNotifier(repo);
    });

class CardsNotifier extends StateNotifier<List<UserCard>> {
  final CardRepository _repo;

  CardsNotifier(this._repo) : super([]) {
    loadCards();
  }

  void loadCards() {
    state = _repo.getAllCards();
  }

  void addHabit(UserCard card) {
    _repo.saveCard(card);
    loadCards();
  }

  void deleteHabit(UserCard card) {
    _repo.deleteCard(card);
    loadCards();
  }
}
