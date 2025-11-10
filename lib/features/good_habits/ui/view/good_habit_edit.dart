import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/widgets/divider/sized_box_divider.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/model/good_habit.dart';
import '../viewmodel/good_habit_edit_viewmodel.dart';

class GoodHabitEdit extends ConsumerStatefulWidget {
  final GoodHabit habit;
  final bool isNew;

  const GoodHabitEdit({super.key, required this.habit, required this.isNew});

  @override
  ConsumerState<GoodHabitEdit> createState() => _GoodHabitEditState();
}

class _GoodHabitEditState extends ConsumerState<GoodHabitEdit> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final formState = ref.read(goodHabitFormProvider(widget.habit));
    _nameController = TextEditingController(text: formState.name);
    _descriptionController = TextEditingController(text: formState.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(goodHabitFormProvider(widget.habit));
    final formNotifier = ref.read(goodHabitFormProvider(widget.habit).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.edit),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          TextButton.icon(
            onPressed: () => _saveChanges(),
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
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
                      onChanged: formNotifier.updateName,
                    ),
                    const SizedBox(height: 8),
                    _dateFields(formState, formNotifier),
                    const Divider(),
                    _isOccuringRadioButtons(formState, formNotifier),
                    const Divider(),
                    SizedBoxDivider(),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: t.notes,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                      onChanged: formNotifier.updateDescription,
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

  Widget _dateFields(GoodHabitFormState state, GoodHabitFormNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
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
            onTap: () =>
                _pickDate(isFrom: true, notifier: notifier, state: state),
          ),
        ),
        SizedBoxDivider(),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                const Icon(Icons.date_range),
                SizedBoxDivider(),
                Text(t.to),
                SizedBoxDivider(),
                Text(
                  state.toDate != null
                      ? DateUtil.returnDateInStringFormat(state.toDate!)
                      : t.not_set,
                ),
              ],
            ),
            onTap: () =>
                _pickDate(isFrom: false, notifier: notifier, state: state),
          ),
        ),
      ],
    );
  }

  Widget _isOccuringRadioButtons(
    GoodHabitFormState state,
    GoodHabitFormNotifier notifier,
  ) {
    return RadioGroup<Occuring>(
      groupValue: state.occuring,
      onChanged: (Occuring? value) {
        notifier.updateOccuring(value!);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: Occuring.ocurring,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                OccuringIcon(isOccuringFlag: true),
                SizedBoxDivider(),
                Text(t.occuring),
              ],
            ),
          ),
          RadioListTile(
            value: Occuring.notOccuring,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                OccuringIcon(isOccuringFlag: false),
                SizedBoxDivider(),
                Text(t.not_occuring),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({
    required bool isFrom,
    required GoodHabitFormNotifier notifier,
    required GoodHabitFormState state,
  }) async {
    final currentDate = isFrom
        ? state.fromDate
        : state.toDate ?? DateTime.now();

    final newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDate == null) return;

    if (isFrom) {
      notifier.updateFromDate(newDate);
    } else {
      notifier.updateToDate(newDate);
    }
  }

  void _saveChanges() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formNotifier = ref.read(goodHabitFormProvider(widget.habit).notifier);
    formNotifier.saveChanges();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.change_saved)));
    router.pop();
    if (!widget.isNew) router.pop();
  }
}
