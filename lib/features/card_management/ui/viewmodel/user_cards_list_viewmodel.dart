import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userCardsListViewModelProvider =
    NotifierProvider<UserCardsListViewModel, List<UserCard>>(
      UserCardsListViewModel.new,
    );

final filteredUserCardsProvider = Provider<List<UserCard>>((ref) {
  final allCards = ref.watch(cardsProvider);
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return [];
  return allCards
      .where((card) => card.userId == currentUserId)
      .where((h) => !h.isDeleted)
      .toList();
});

class UserCardsListViewModel extends Notifier<List<UserCard>> {
  final Set<int> _selectedIds = {};

  @override
  List<UserCard> build() => [];

  void setCards(List<UserCard> cards) {
    state = cards;
  }

  bool get isSelectionMode => _selectedIds.isNotEmpty;

  Set<int> get selectedIds => _selectedIds;

  void toggleSelection(UserCard card) {
    if (_selectedIds.contains(card.id)) {
      _selectedIds.remove(card.id);
    } else {
      _selectedIds.add(card.id!);
    }
    state = [...state];
  }

  void startSelection(UserCard card) {
    _selectedIds.add(card.id!);
    state = [...state];
  }

  void clearSelection() {
    _selectedIds.clear();
    state = [...state];
  }

  bool isSelected(UserCard card) =>
      _selectedIds.contains(card.id);

  List<UserCard> get selectedCards =>
      state.where((c) => _selectedIds.contains(c.id)).toList();

  void sort(UserCardSort sort) {
    switch (sort) {
      case UserCardSort.nameAsc:
        state = [...state]
          ..sort(
                (a, b) => a.names.values.first
                .toLowerCase()
                .compareTo(b.names.values.first.toLowerCase()),
          );
        break;
      case UserCardSort.nameDesc:
        state = [...state]
          ..sort(
                (a, b) => b.names.values.first
                .toLowerCase()
                .compareTo(a.names.values.first.toLowerCase()),
          );
        break;
    }
  }

  void selectAll(List<UserCard> allCards) {
    if (_selectedIds.length == allCards.length) {
      clearSelection();
    } else {
      _selectedIds.clear();
      _selectedIds.addAll(allCards.where((c) => c.id != null).map((c) => c.id!));
      state = [...state];
    }
  }
}

enum UserCardSort { nameAsc, nameDesc }
