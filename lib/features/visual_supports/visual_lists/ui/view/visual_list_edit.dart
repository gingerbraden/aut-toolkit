import 'dart:io';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/widgets/info_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../router.dart';
import '../../../../../core/utils/router_utils.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/visual_list.dart';
import '../viewmodel/visual_list_edit_viewmodel.dart';

class VisualListEdit extends ConsumerStatefulWidget {
  final VisualList list;
  final bool isNew;

  const VisualListEdit({super.key, required this.list, required this.isNew});

  @override
  ConsumerState<VisualListEdit> createState() => _VisualListEditState();
}

class _VisualListEditState extends ConsumerState<VisualListEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(visualListEditViewModelProvider(widget.list));
    _nameController = TextEditingController(text: state.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(visualListEditViewModelProvider(widget.list));

    final viewModel = ref.read(
      visualListEditViewModelProvider(widget.list).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? t.create : t.edit),
        actions: [
          TextButton.icon(
            onPressed: () => _saveChanges(viewModel),
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: t.name,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? t.please_enter_name
                        : null,
                    onChanged: viewModel.updateName,
                  ),
                  const SizedBox(height: 12),
                  const Divider(),

                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: formState.steps.length + 1,
                    onReorder: (oldIndex, newIndex) {
                      viewModel.reorderSteps(oldIndex, newIndex);
                    },
                    itemBuilder: (_, index) {
                      if (index < formState.steps.length) {
                        final card = formState.steps[index];
                        return ListTile(
                          key: ValueKey(card),
                          title: Text(
                            card.names[LocaleSettings
                                    .currentLocale
                                    .languageCode] ??
                                'Card',
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _cardImage(card.localImgPath),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => viewModel.deleteStep(index),
                              ),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                        );
                      } else {
                        return ListTile(
                          key: const ValueKey('add_card_button'),
                          title: Text(t.add_step),
                          leading: const Icon(Icons.add),
                          onTap: () => _pickCard(null),
                        );
                      }
                    },
                  ),
                  if (!widget.isNew)
                    Column(
                      children: [
                        const Divider(),
                        if (!widget.isNew)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(t.really_delete_object),
                                        content: Text(t.yes),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
                                            child: Text(t.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.redAccent,
                                            ),
                                            child: Text(t.delete),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed == true) {
                                    viewModel.deleteBoard();
                                    router.pop();
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      t.delete,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                  InfoSmallText(description: t.visual_schedule_info),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardImage(String imgPath) {
    return Image.file(
      File(imgPath),
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade300,
        child: const Icon(Icons.question_mark),
      ),
    );
  }

  Future<void> _pickCard(int? index) async {
    router.push(
      RouterUtils.getNewVisualListCardPickerPath(),
      extra: {
        'onSelected': (UserCard card) {
          final viewModel = ref.read(
            visualListEditViewModelProvider(widget.list).notifier,
          );
          if (index != null) {
            viewModel.updateStep(index, card);
          } else {
            viewModel.addStep(card);
          }
        },
      },
    );
  }

  void _saveChanges(VisualListEditViewModel viewModel) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    viewModel.saveChanges();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.change_saved),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }
}
