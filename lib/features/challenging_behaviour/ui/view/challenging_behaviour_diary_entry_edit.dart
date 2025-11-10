import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/widgets/divider/divider_sized_box_divider.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/challenging_behaviour_diary_entry_edit_viewmodel.dart';

class ChallengingBehaviourDiaryEntryEdit extends ConsumerStatefulWidget {
  final ChallengingBehaviourDiaryEntry entry;
  final int cbId;
  final bool isNew;

  const ChallengingBehaviourDiaryEntryEdit({
    super.key,
    required this.entry,
    required this.isNew,
    required this.cbId,
  });

  @override
  ConsumerState<ChallengingBehaviourDiaryEntryEdit> createState() =>
      _ChallengingBehaviourDiaryEntryEditState();
}

class _ChallengingBehaviourDiaryEntryEditState
    extends ConsumerState<ChallengingBehaviourDiaryEntryEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _locationController;
  late TextEditingController _durationController;
  late TextEditingController _circumstancesController;
  late TextEditingController _peopleController;
  late TextEditingController _outcomeController;
  late TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.entry.location);
    _durationController = TextEditingController(
      text: widget.entry.duration.toString(),
    );
    _circumstancesController = TextEditingController(
      text: widget.entry.circumstances,
    );
    _peopleController = TextEditingController();
    _outcomeController = TextEditingController(text: widget.entry.outcome);
    _reflectionController = TextEditingController(
      text: widget.entry.reflection,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(challengingBehaviourDiaryEntryEditViewModelProvider.notifier)
          .init(
            entry: widget.entry,
            isNew: widget.isNew,
            cbId: widget.cbId,
            context: context,
          );
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _durationController.dispose();
    _circumstancesController.dispose();
    _peopleController.dispose();
    _outcomeController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      challengingBehaviourDiaryEntryEditViewModelProvider,
    );
    final viewModel = ref.read(
      challengingBehaviourDiaryEntryEditViewModelProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNew
              ? t.create
              : '${t.edit} ${DateUtil.returnDateInStringFormat(widget.entry.date)}',
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          TextButton.icon(
            onPressed: () => viewModel.saveChanges(
              ref: ref,
              formKey: _formKey,
              locationController: _locationController,
              durationController: _durationController,
              circumstancesController: _circumstancesController,
              outcomeController: _outcomeController,
              reflectionController: _reflectionController,
            ),
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _locationTextField(),
                  SizedBoxDivider(),
                  _durationDateFields(state, viewModel),
                  DividerSizedBoxDivider(),
                  _circumstancesField(),
                  DividerSizedBoxDivider(),
                  _peopleField(state, viewModel),
                  DividerSizedBoxDivider(),
                  _outcomeField(),
                  DividerSizedBoxDivider(),
                  _reflectionField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationTextField() => TextFormField(
    controller: _locationController,
    decoration: InputDecoration(
      labelText: t.location,
      border: const OutlineInputBorder(),
    ),
    validator: (value) =>
        value == null || value.isEmpty ? t.please_enter_location : null,
  );

  Widget _durationDateFields(
    ChallengingBehaviourDiaryEntryEditState state,
    ChallengingBehaviourDiaryEntryEditViewModel viewModel,
  ) {
    return Row(
      children: [
        Expanded(flex: 3, child: _durationField()),
        Expanded(flex: 4, child: _dateField(state, viewModel)),
      ],
    );
  }

  Widget _dateField(
    ChallengingBehaviourDiaryEntryEditState state,
    ChallengingBehaviourDiaryEntryEditViewModel viewModel,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.date_range),
          SizedBoxDivider(),
          Text(DateUtil.returnDateInStringFormatWithTime(state.date)),
        ],
      ),
      onTap: viewModel.pickDateTime,
    );
  }

  Widget _durationField() => TextFormField(
    controller: _durationController,
    decoration: InputDecoration(
      labelText: '${t.duration} (${t.few_minutes})',
      border: const OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
    validator: (value) {
      if (value == null || value.isEmpty) return t.please_enter_duration;
      final num? parsed = num.tryParse(value);
      if (parsed == null || parsed <= 0) return t.invalid_value;
      return null;
    },
  );

  Widget _circumstancesField() => TextFormField(
    controller: _circumstancesController,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: t.circumstances,
      border: const OutlineInputBorder(),
    ),
    maxLines: 3,
  );

  Widget _peopleField(
    ChallengingBehaviourDiaryEntryEditState state,
    ChallengingBehaviourDiaryEntryEditViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.people_present, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: state.people
              .map(
                (p) => Chip(
                  label: Text(p),
                  onDeleted: () => viewModel.removePerson(p),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _peopleController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: t.after_typing_enter_submit,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (val) {
            viewModel.addPerson(val);
            _peopleController.clear();
          },
          onChanged: (val) {
            if (val.endsWith(' ') || val.endsWith(',')) {
              viewModel.addPerson(val.trim().replaceAll(',', ''));
              _peopleController.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _outcomeField() => TextFormField(
    controller: _outcomeController,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: t.outcome,
      border: const OutlineInputBorder(),
    ),
    maxLines: 3,
  );

  Widget _reflectionField() => TextFormField(
    controller: _reflectionController,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: t.reflection,
      border: const OutlineInputBorder(),
    ),
    maxLines: 5,
  );
}
