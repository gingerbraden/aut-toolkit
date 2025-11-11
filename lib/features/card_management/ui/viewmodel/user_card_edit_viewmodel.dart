import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userCardEditViewModelProvider = NotifierProvider.autoDispose
    .family<UserCardEditViewModel, UserCardEditState, UserCard>(
      UserCardEditViewModel.new,
    );

class UserCardEditViewModel extends Notifier<UserCardEditState> {
  final UserCard _card;

  UserCardEditViewModel(this._card);

  @override
  UserCardEditState build() {
    return UserCardEditState(
      formKey: GlobalKey<FormState>(),
      asyncPrefs: SharedPreferencesAsync(),
      name: _card.names.containsKey(LocaleSettings.currentLocale.languageCode)
          ? _card.names[LocaleSettings.currentLocale.languageCode]!
          : "",
      imagePath: _card.localImgPath,
      arasaacId: _card.arasaacId,
    );
  }

  void updateName(String name) => state = state.copyWith(name: name);

  Future<UserCardEditResult> pickImage(BuildContext context) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.create_card_decision),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, 'gallery'),
            child: Text(t.from_gallery),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'arasaac'),
            child: Text(t.arasaac_icons),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(t.cancel),
          ),
        ],
      ),
    );

    if (choice == null) return UserCardEditResult.none;

    state = state.copyWith(isLoadingImage: true);
    String? imgPath;
    String? arasaacId;

    try {
      if (choice == 'gallery') {
        imgPath = await ImageUtil.pickAndStoreImage(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).textTheme.headlineLarge!.color!,
        );
      } else if (choice == 'arasaac') {
        await router.push(RouterUtils.getCardsARASAACPath());
        String? path = await state.asyncPrefs.getString('imgPath');
        if (path!.isNotEmpty) {
          imgPath = await ImageUtil.saveImageFromUrl(path);
          arasaacId = imgPath!.split("/").last.split("_").first;
          state.asyncPrefs.setString('imgPath', "");
          state.copyWith(arasaacId: int.parse(arasaacId));
        }
      }
      if (imgPath != null) {
        if (state.imagePath != null) {
          ImageUtil.deleteImage(state.imagePath!);
        }
        state = state.copyWith(imagePath: imgPath);
      }
    } catch (_) {
      state = state.copyWith(isLoadingImage: false);
      return UserCardEditResult.error;
    } finally {
      state = state.copyWith(isLoadingImage: false);
    }

    return UserCardEditResult.none;
  }

  Future<bool> deleteImage() async {
    if (state.imagePath != null) {
      ImageUtil.deleteImage(state.imagePath!);
      state = state.copyWith(imagePath: null);
      return true;
    }
    return false;
  }

  Future<UserCardEditResult> saveUserCard(UserCard card, bool isNew) async {
    if (state.formKey.currentState?.validate() ?? false) {
      if (state.imagePath != null && state.imagePath!.isNotEmpty) {
        final updatedCard = UserCard(
          id: card.id,
          arasaacId: state.arasaacId != null ? state.arasaacId! : null,
          userId: card.userId,
          names: {LocaleSettings.currentLocale.languageCode: state.name},
          localImgPath: state.imagePath ?? '',
        );
        ref.read(cardsProvider.notifier).addCard(updatedCard);
        return UserCardEditResult.saved;
      } else {
        return UserCardEditResult.noImage;
      }
    }
    return UserCardEditResult.none;
  }
}

enum UserCardEditResult { none, saved, noImage, error, deleted }

class UserCardEditState {
  final GlobalKey<FormState> formKey;
  final String name;
  final String? imagePath;
  final int? arasaacId;
  final bool isLoadingImage;
  final SharedPreferencesAsync asyncPrefs;

  UserCardEditState({
    required this.formKey,
    required this.name,
    this.imagePath,
    this.arasaacId,
    this.isLoadingImage = false,
    required this.asyncPrefs,
  });

  UserCardEditState copyWith({
    String? imagePath,
    int? arasaacId,
    bool? isLoadingImage,
    String? name,
  }) {
    return UserCardEditState(
      formKey: formKey,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      arasaacId: arasaacId ?? this.arasaacId,
      isLoadingImage: isLoadingImage ?? this.isLoadingImage,
      asyncPrefs: asyncPrefs,
    );
  }
}
