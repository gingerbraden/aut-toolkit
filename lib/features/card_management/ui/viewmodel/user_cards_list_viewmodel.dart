import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredUserCardsProvider = Provider<List<UserCard>>((ref) {
  final allCards = ref.watch(cardsProvider);
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return [];
  return allCards.where((card) => card.userId == currentUserId).toList();
});

enum UserCardSort { nameAsc, nameDesc }

class UserCardsListViewModel extends Notifier<List<UserCard>> {
  @override
  List<UserCard> build() => [];

  void setCards(List<UserCard> cards) {
    state = cards;
  }

  void sort(UserCardSort sort) {
    switch (sort) {
      case UserCardSort.nameAsc:
        state = [...state]
          ..sort(
            (a, b) => a.names.values.first.toLowerCase().compareTo(
              b.names.values.first.toLowerCase(),
            ),
          );
        break;
      case UserCardSort.nameDesc:
        state = [...state]
          ..sort(
            (a, b) => b.names.values.first.toLowerCase().compareTo(
              a.names.values.first.toLowerCase(),
            ),
          );
        break;
    }
  }
}

final userCardsListViewModelProvider =
    NotifierProvider<UserCardsListViewModel, List<UserCard>>(
      UserCardsListViewModel.new,
    );
