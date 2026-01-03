import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/card_util.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/user_card_edit_viewmodel.dart';

class UserCardEdit extends ConsumerStatefulWidget {
  const UserCardEdit({super.key, required this.isNew, required this.card});

  final bool isNew;
  final UserCard card;

  @override
  ConsumerState<UserCardEdit> createState() => _UserCardEditState();
}

class _UserCardEditState extends ConsumerState<UserCardEdit> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(userCardEditViewModelProvider(widget.card));
    _nameController = TextEditingController(text: state.name);
  }

  @override
  Future<void> dispose() async {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      userCardEditViewModelProvider(widget.card).notifier,
    );
    final state = ref.watch(userCardEditViewModelProvider(widget.card));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.isNew ? t.create : t.edit),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => handleSave(viewModel, context),
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.BASE_APP_UI_PADDING,
          ),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
              child: Form(
                key: state.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      onChanged: viewModel.updateName,
                      decoration: InputDecoration(
                        labelText: t.name,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? t.please_enter_name
                          : null,
                    ),
                    const SizedBoxDivider(),
                    DropdownButtonFormField<WordCategory>(
                      initialValue: ref
                          .watch(userCardEditViewModelProvider(widget.card))
                          .wordCategory,
                      decoration: InputDecoration(
                        labelText: t.word_category,
                        border: const OutlineInputBorder(),
                      ),
                      items: WordCategory.values.map((category) {
                        final label = CardUtil.getWordCategoryLabel(category);
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: CardUtil.getColorForWordCat(category),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (category) {
                        ref
                            .read(
                              userCardEditViewModelProvider(
                                widget.card,
                              ).notifier,
                            )
                            .updateWordCategory(category);
                      },
                      validator: (value) =>
                          value == null ? t.please_choose_word_category : null,
                    ),
                    const SizedBoxDivider(),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: state.imagePath != null ? 12.0 : 0,
                        top: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: state.isLoadingImage
                                ? null
                                : () => handlePickImage(viewModel, context),
                            icon: const Icon(Icons.add_a_photo),
                            label: Text(
                              state.imagePath!.isEmpty
                                  ? t.load_image
                                  : t.change_image,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => viewModel.playAudio(
                              _nameController.text.toString(),
                            ),
                            icon: const Icon(Icons.audiotrack_outlined),
                            label: Text(t.tts_test),
                          ),
                        ],
                      ),
                    ),
                    if (state.isLoadingImage)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.imagePath != null &&
                        state.imagePath!.isNotEmpty)
                      SquareImageFilledWidth(imageFilePath: state.imagePath!),
                    SizedBoxDivider(),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.card_name_language_info,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handlePickImage(
    UserCardEditViewModel viewModel,
    BuildContext context,
  ) async {
    final result = await viewModel.pickImage(context);
    if (result == UserCardEditResult.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.error_occured),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> handleDeleteImage(
    UserCardEditViewModel viewModel,
    BuildContext context,
  ) async {
    final deleted = await viewModel.deleteImage();
    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.image_deleted),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> handleSave(
    UserCardEditViewModel viewModel,
    BuildContext context,
  ) async {
    final result = await viewModel.saveUserCard(widget.card, widget.isNew);
    switch (result) {
      case UserCardEditResult.saved:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.change_saved),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ),
        );
        router.pop();
        if (!widget.isNew) router.pop();
        break;
      case UserCardEditResult.noImage:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.no_image_set),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      default:
        break;
    }
  }
}
