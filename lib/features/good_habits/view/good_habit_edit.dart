import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/good_habits/provider/good_habits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';
import '../domain/model/good_habit.dart';

enum Occuring { ocurring, notOccuring }


class GoodHabitEdit extends ConsumerStatefulWidget {
  final GoodHabit habit;
  final bool isNew;
  const GoodHabitEdit({super.key, required this.habit, required this.isNew});

  @override
  ConsumerState<GoodHabitEdit> createState() => _GoodHabitEditState();
}

class _GoodHabitEditState extends ConsumerState<GoodHabitEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Occuring _occuring;
  late DateTime _fromDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController =
        TextEditingController(text: widget.habit.description);
    _occuring =
    widget.habit.isOcuringFlag ? Occuring.ocurring : Occuring.notOccuring;
    _fromDate = widget.habit.from;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.isNew
            ? t.create
            : '${t.edit} ${widget.habit.name}'),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              _saveChanges();
            },
            icon: const Icon(Icons.check),
            label: Text(
              t.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _nameTextField(),
                    _dateFields(),
                    const Divider(),
                    _isOccuringRadioButtons(),
                    const Divider(),
                    SizedBoxDivider(),
                    _descriptionTextField()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: t.name,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? t.please_enter_name : null,
      ),
    );
  }

  Widget _dateFields() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,8,0,0),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBoxDivider(),
                  Text(t.from),
                  SizedBoxDivider(),
                  Text(DateUtil.returnDateInStringFormat(_fromDate))
                ],
              ),
              onTap: () => _pickDate(isFrom: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _isOccuringRadioButtons() {
    return RadioGroup<Occuring>(
      groupValue: _occuring,
      onChanged: (Occuring? value) {
        setState(() {
          _occuring = value!;
        });
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
            ),),
          RadioListTile(
            value: Occuring.notOccuring,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                OccuringIcon(isOccuringFlag: false),
                SizedBoxDivider(),
                Text(t.not_occuring),
              ],
            ),)
        ],
      ),
    );
  }

  Widget _descriptionTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,8,0,0),
      child: TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: t.notes,
          border: OutlineInputBorder(),
        ),
        maxLines: 10,
      ),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = _fromDate;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;

    setState(() {
        _fromDate = newDate;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedHabit = GoodHabit(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          isOcuringFlag: _occuring == Occuring.ocurring,
          from: _fromDate,
          id: widget.habit.id,
          userId: widget.habit.userId
      );
      ref.read(goodHabitsProvider.notifier).addHabit(updatedHabit);
      setState(() {
      });
      router.pop();
      if (!widget.isNew) {
        router.pop();
      }
    }
  }
}
