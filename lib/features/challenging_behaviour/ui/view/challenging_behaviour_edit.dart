import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/core/widgets/info_small_text.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../domain/model/challenging_behaviour.dart';
import '../viewmodel/challenging_behaviour_edit_viewmodel.dart';

class ChallengingBehaviourEdit extends ConsumerStatefulWidget {
  final ChallengingBehaviour cb;
  final bool isNew;

  const ChallengingBehaviourEdit({
    super.key,
    required this.cb,
    required this.isNew,
  });

  @override
  ConsumerState<ChallengingBehaviourEdit> createState() =>
      _ChallengingBehaviourEditScreenState();
}

class _ChallengingBehaviourEditScreenState
    extends ConsumerState<ChallengingBehaviourEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cb.name);
    _descriptionController = TextEditingController(text: widget.cb.description);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(challengingBehaviourEditViewModelProvider(widget.cb).notifier);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      challengingBehaviourEditViewModelProvider(widget.cb),
    );
    final viewModel = ref.read(
      challengingBehaviourEditViewModelProvider(widget.cb).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? t.create : t.edit),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              if (!(_formKey.currentState?.validate() ?? false)) return;

              viewModel.saveChanges();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.change_saved),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                ),
              );

              router.pop();
              if (!widget.isNew) {
                router.pop(true);
              }
            },
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
                key: _formKey,
                child: Column(
                  children: [
                    _nameTextField(),
                    SizedBox(height: 8),
                    _dateField(state, viewModel),
                    InfoSmallText(description: t.from_info),
                    SizedBox(height: 8),
                    const Divider(),
                    _occuringRadioGroup(state, viewModel),
                    InfoSmallText(description: t.behaviour_occuring_info),
                    SizedBox(height: 8),
                    const Divider(),
                    SizedBoxDivider(),
                    _descriptionTextField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() => TextFormField(
    controller: _nameController,
    onChanged: ref
        .read(challengingBehaviourEditViewModelProvider(widget.cb).notifier)
        .updateName,
    decoration: InputDecoration(
      labelText: t.name,
      border: const OutlineInputBorder(),
    ),
    validator: (value) =>
        value == null || value.isEmpty ? t.please_enter_name : null,
  );

  Widget _dateField(
    ChallengingBehaviourEditState state,
    ChallengingBehaviourEditViewModel viewModel,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Icon(Icons.date_range),
          SizedBoxDivider(),
          Text(t.from),
          SizedBoxDivider(),
          Text(DateUtil.returnDateInStringFormat(state.fromDate)),
        ],
      ),
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: ref
              .read(challengingBehaviourEditViewModelProvider(widget.cb))
              .fromDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (newDate != null) {
          ref
              .read(
                challengingBehaviourEditViewModelProvider(widget.cb).notifier,
              )
              .updateDate(newDate);
        }
      },
    );
  }

  Widget _occuringRadioGroup(
    ChallengingBehaviourEditState state,
    ChallengingBehaviourEditViewModel viewModel,
  ) {
    return RadioGroup<Occuring>(
      groupValue: state.occuring,
      onChanged: (value) => viewModel.updateOccuring(value!),
      child: Column(
        children: [
          RadioListTile(
            value: Occuring.ocurring,
            title: Row(
              children: [
                const OccuringIcon(isOccuringFlag: true),
                SizedBoxDivider(),
                Text(t.occuring),
              ],
            ),
          ),
          RadioListTile(
            value: Occuring.notOccuring,
            title: Row(
              children: [
                const OccuringIcon(isOccuringFlag: false),
                SizedBoxDivider(),
                Text(t.not_occuring),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionTextField() => TextFormField(
    controller: _descriptionController,
    onChanged: ref
        .read(challengingBehaviourEditViewModelProvider(widget.cb).notifier)
        .updateDescription,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: t.notes,
      border: const OutlineInputBorder(),
    ),
    maxLines: 10,
  );
}
