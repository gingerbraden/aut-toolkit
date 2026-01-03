import 'dart:convert';

import 'package:aut_toolkit/core/model/Pictogram.dart';
import 'package:aut_toolkit/core/repository/arasaac_repository.dart';
import 'package:aut_toolkit/core/utils/string_util.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router.dart';

final arasaacCardsSearchViewModelProvider =
    NotifierProvider<ARASAACCardsSearchViewModel, ARASAACCardsSearchState>(
      ARASAACCardsSearchViewModel.new,
    );

class ARASAACCardsSearchViewModel extends Notifier<ARASAACCardsSearchState> {
  @override
  ARASAACCardsSearchState build() {
    final repo = ARASAACRepository();
    final controller = TextEditingController();
    final prefs = SharedPreferencesAsync();
    _loadTranslations();
    return ARASAACCardsSearchState(
      repo: repo,
      searchController: controller,
      asyncPrefs: prefs,
    );
  }

  Future<void> _loadTranslations() async {
    final jsonString = await rootBundle.loadString('res/sk-en.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final parsed = jsonMap.map(
      (key, value) => MapEntry(
        StringUtils().removeDiacritics(key),
        List<String>.from(value),
      ),
    );
    state = state.copyWith(translations: parsed);
  }

  void performSearch(BuildContext context) {
    final query = StringUtils().removeDiacritics(
      state.searchController.text.trim(),
    );
    if (query == state.lastQuery) {
      return;
    }
    if (query.isEmpty || !state.translations.keys.contains(query)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.no_icons_found),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
      return;
    }
    final future = state.repo.searchPictograms(
      state.translations[query]!.join(" "),
    );
    if (!ref.mounted) return;
    state = state.copyWith(futurePictograms: future, lastQuery: query);
  }

  Future<bool?> showConfirmDialog(
    BuildContext context,
    Pictogram pictogram,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.use_this_image),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                state.repo.getPictogramUrl(pictogram.id),
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.no),
          ),
          FilledButton(
            onPressed: () => {
              state.asyncPrefs.setString(
                'imgPath',
                state.repo.getPictogramUrl(pictogram.id),
              ),
              router.pop(true),
            },
            child: Text(t.yes),
          ),
        ],
      ),
    );
  }

  void clearState() {
    Future.delayed(
      Duration(milliseconds: 500),
      () => {
        state.searchController.clear(),

        state = state.copyWith(
          futurePictograms: Future.value([]),
          lastQuery: '',
        ),

        state.asyncPrefs.setString('imgPath', ''),
      },
    );
  }
}

class ARASAACCardsSearchState {
  final ARASAACRepository repo;
  final TextEditingController searchController;
  final SharedPreferencesAsync asyncPrefs;
  final Future<List<Pictogram>>? futurePictograms;
  final Map<String, List<String>> translations;
  final String lastQuery;

  ARASAACCardsSearchState({
    required this.repo,
    required this.searchController,
    required this.asyncPrefs,
    this.futurePictograms,
    this.translations = const {},
    this.lastQuery = '',
  });

  ARASAACCardsSearchState copyWith({
    Future<List<Pictogram>>? futurePictograms,
    Map<String, List<String>>? translations,
    String? lastQuery,
  }) {
    return ARASAACCardsSearchState(
      repo: repo,
      searchController: searchController,
      asyncPrefs: asyncPrefs,
      futurePictograms: futurePictograms ?? this.futurePictograms,
      translations: translations ?? this.translations,
      lastQuery: lastQuery ?? this.lastQuery,
    );
  }
}
