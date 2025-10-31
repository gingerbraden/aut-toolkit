import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/widgets/divider/divider_sized_box_divider.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../i18n/strings.g.dart';

class ChallengingBehaviourDiaryEntryEdit extends ConsumerStatefulWidget {
  final ChallengingBehaviourDiaryEntry entry;
  final int cbId;
  final bool isNew;

  const ChallengingBehaviourDiaryEntryEdit({
    super.key,
    required this.entry,
    required this.isNew,
    required this.cbId
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

  final List<String> _people = [];

  void _addPerson(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    setState(() {
      _people.add(text);
      _peopleController.clear();
    });
  }

  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.entry.location);
    _durationController =
        TextEditingController(text: widget.entry.duration.toString());
    _circumstancesController =
        TextEditingController(text: widget.entry.circumstances);
    _peopleController =
        TextEditingController();
    _outcomeController = TextEditingController(text: widget.entry.outcome);
    _reflectionController = TextEditingController(text: widget.entry.reflection);
    _date = widget.entry.date;
    _people.addAll(widget.entry.people);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew
            ? t.create
            : '${t.edit} ${DateUtil.returnDateInStringFormat(widget.entry.date)}'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _locationTextField(),
              SizedBoxDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: _durationField()),
                  Expanded(flex: 2, child: _dateField())
                ],
              ),
              DividerSizedBoxDivider(),
              _circumstancesField(),
              DividerSizedBoxDivider(),
              _peopleField(),
              DividerSizedBoxDivider(),
              _outcomeField(),
              DividerSizedBoxDivider(),
              _reflectionField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: _locationController,
        decoration: InputDecoration(
          labelText: t.location,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? t.please_enter_location : null,
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.date_range),
            SizedBoxDivider(),
            Text(DateUtil.returnDateInStringFormatWithTime(_date)), // show both date & time
          ],
        ),
        onTap: _pickDateTime,
      ),
    );
  }

  Future<void> _pickDateTime() async {
    // Pick date first
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    // Then pick time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    if (pickedTime == null) return;

    // Combine date and time into a DateTime object
    setState(() {
      _date = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }



  Widget _durationField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: _durationController,
        decoration: InputDecoration(
          labelText: '${t.duration} (${t.few_minutes})',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return t.please_enter_duration;
          final num? parsed = num.tryParse(value);
          if (parsed == null || parsed <= 0) return t.invalid_value;
          return null;
        },
      ),
    );
  }

  Widget _circumstancesField() {
    return TextFormField(
      controller: _circumstancesController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: t.circumstances,
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }



  Widget _peopleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.people_present,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Chips row
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: _people
              .map((c) => Chip(
            label: Text(c),
            onDeleted: () {
              setState(() => _people.remove(c));
            },
          ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // TextField for adding new chips
        TextField(
          controller: _peopleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: t.after_typing_enter_submit,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _addPerson,
          onChanged: (value) {
            if (value.endsWith(' ') || value.endsWith(',')) {
              _addPerson(value.trim().replaceAll(',', ''));
            }
          },
        ),
      ],
    );
  }

  Widget _outcomeField() {
    return TextFormField(
      controller: _outcomeController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: t.outcome,
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _reflectionField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _reflectionController,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: t.reflection,
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
      ),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final entry = ChallengingBehaviourDiaryEntry(
      id: widget.entry.id,
      location: _locationController.text.trim(),
      date: _date,
      duration: int.parse(_durationController.text),
      circumstances: _circumstancesController.text.trim(),
      people: _people,
      outcome: _outcomeController.text.trim(),
      reflection: _reflectionController.text.trim(),
    );

    ref
        .read(challengingBehavioursProvider.notifier)
        .addDiaryEntry(widget.cbId, entry); // you’ll need to implement this
    router.pop();
    if (!widget.isNew) router.pop();
  }
}
