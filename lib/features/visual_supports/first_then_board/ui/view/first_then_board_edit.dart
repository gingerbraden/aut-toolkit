import 'dart:io';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/router.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/first_then_board.dart';
import '../viewmodel/first_then_board_edit_viewmodel.dart';

class FirstThenBoardEdit extends ConsumerStatefulWidget {
  final FirstThenBoard board;
  final bool isNew;

  const FirstThenBoardEdit({
    super.key,
    required this.board,
    required this.isNew,
  });

  @override
  ConsumerState<FirstThenBoardEdit> createState() => _FirstThenBoardEditState();
}

class _FirstThenBoardEditState extends ConsumerState<FirstThenBoardEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(firstThenBoardEditViewModelProvider(widget.board));
    _nameController = TextEditingController(text: state.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      firstThenBoardEditViewModelProvider(widget.board),
    );
    final viewModel = ref.read(
      firstThenBoardEditViewModelProvider(widget.board).notifier,
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
        padding: EdgeInsets.only(
          left: AppConstants.BASE_APP_UI_PADDING,
          right: AppConstants.BASE_APP_UI_PADDING,
          bottom: AppConstants.BASE_APP_UI_PADDING,
        ),
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
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? t.please_enter_name
                        : null,
                    onChanged: viewModel.updateName,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Divider(),
                  ),
                  _imageTile(t.first, formState.first),
                  _imageTile(t.then, formState.then),
                  if (!widget.isNew)
                    Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.deleteBoard();
                                router.pop();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete, color: Colors.redAccent,),
                                  SizedBox(width: 8),
                                  Text(t.delete, style: TextStyle(color: Colors.redAccent),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageTile(String title, UserCard card) {
    return ListTile(
      title: Text(
        '$title ${card.names[LocaleSettings.currentLocale.languageCode] ?? AppConstants.EMPTY_STRING}',
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _cardImage(card.localImgPath),
      ),
      trailing: const Icon(Icons.edit),
      onTap: () => _pickCard(context, card, title == t.first),
    );
  }

  Widget _cardImage(String imgPath) {
    return Image.file(
      File(imgPath),
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      key: ValueKey(imgPath),
      errorBuilder: (_, _, _) => Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade300,
        child: const Icon(Icons.question_mark),
      ),
    );
  }

  Future<void> _pickCard(
    BuildContext context,
    UserCard current,
    bool isFirst,
  ) async {
    router.push(
      RouterUtils.getNewFirstThenBoardUserCardPickerPath(),
      extra: {
        'current': current,
        'onSelected': (UserCard card) {
          final viewModel = ref.read(
            firstThenBoardEditViewModelProvider(widget.board).notifier,
          );
          if (isFirst) {
            viewModel.updateFirst(card);
          } else {
            viewModel.updateThen(card);
          }
        },
      },
    );
  }

  void _saveChanges(FirstThenBoardEditViewModel viewModel) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    viewModel.saveChanges();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.change_saved),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
    Navigator.of(context).pop();
  }
}
