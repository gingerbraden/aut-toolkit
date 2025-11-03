import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/core/utils/scaffold_messenger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../core/widgets/icon/eating_icon.dart';
import '../../../i18n/strings.g.dart';
import '../../selected_person/provider/selected_person_notifier.dart';
import '../domain/model/eating_habit.dart';
import '../provider/eating_habits_notifier.dart';

enum EatingStatus { eating, notEating }

class EatingHabitEdit extends ConsumerStatefulWidget {
  final EatingHabit habit;
  final bool isNew;

  const EatingHabitEdit({super.key, required this.habit, required this.isNew});

  @override
  ConsumerState<EatingHabitEdit> createState() => _EditEatingHabitScreenState();
}

class _EditEatingHabitScreenState extends ConsumerState<EatingHabitEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late EatingStatus _eatingStatus;
  late DateTime _fromDate;
  late DateTime? _toDate;
  late String? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController =
        TextEditingController(text: widget.habit.description);
    _eatingStatus =
    widget.habit.isEatingFlag ? EatingStatus.eating : EatingStatus.notEating;
    _fromDate = widget.habit.from;
    _toDate = widget.habit.to;
    _image = widget.habit.imageFilePath;
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
        title: Text(widget.isNew
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
                    _isEatingRadioButtons(),
                    const Divider(),
                    SizedBoxDivider(),
                    _descriptionTextField(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Divider(),
                    ),
                    _imageButtons()

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
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
          SizedBoxDivider(),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBoxDivider(),
                  Text(t.to, style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge),
                  SizedBoxDivider(),
                  Text(_toDate != null
                      ? DateUtil.returnDateInStringFormat(_toDate)
                      : t.not_set)
                ],
              ),
              onTap: () => _pickDate(isFrom: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _isEatingRadioButtons() {
    return RadioGroup<EatingStatus>(
      groupValue: _eatingStatus,
      onChanged: (EatingStatus? value) {
        setState(() {
          _eatingStatus = value!;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: EatingStatus.eating,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                EatingIcon(isEatingFlag: true),
                SizedBoxDivider(),
                Text(t.is_eating),
              ],
            ),),
          RadioListTile(
            value: EatingStatus.notEating,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                EatingIcon(isEatingFlag: false),
                SizedBoxDivider(),
                Text(t.is_not_eating),
              ],
            ),)
        ],
      ),
    );
  }

  Widget _descriptionTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: t.notes,
          border: OutlineInputBorder(),
        ),
        maxLines: 7,
      ),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = isFrom ? _fromDate : _toDate;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;

    setState(() {
      if (isFrom) {
        _fromDate = newDate;
      } else {
        _toDate = newDate;
      }
    });
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedHabit = EatingHabit(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          isEatingFlag: _eatingStatus == EatingStatus.eating,
          from: _fromDate,
          to: _toDate,
          id: widget.habit.id,
          userId: widget.habit.userId,
          selectedPersonId: ref
              .watch(selectedPersonsProvider.notifier)
              .getSelected()
              .id!,
          imageFilePath: _image
      );
      ref.read(eatingHabitsProvider.notifier).addHabit(updatedHabit);
      setState(() {});
      router.pop();
      if (!widget.isNew) {
        router.pop();
      }
    }
  }

  _imageButtons() {
    return _image == null
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final imgPath = await ImageUtil.pickAndStoreImage();
            setState(() {
              _image = imgPath;
            });
            ScaffoldMessengerUtils().showSnackBar(context, t.image_changed);
          },
          icon: const Icon(Icons.add),
          label: Text(t.load_image),
        ),
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final imgPath = await ImageUtil.pickAndStoreImage();
            setState(() {
              ImageUtil.deleteImage(_image!);
              _image = imgPath;
            });
            ScaffoldMessengerUtils().showSnackBar(context, t.image_changed);
          },
          icon: const Icon(Icons.edit),
          label: Text(t.change_image),
        ), ElevatedButton.icon(
          onPressed: () {
            setState(() {
              ImageUtil.deleteImage(_image!);
              _image = null;
            });
            ScaffoldMessengerUtils().showSnackBar(context, t.image_deleted);
          },
          icon: const Icon(Icons.delete, color: Colors.redAccent,),
          label: Text(
            t.delete_image, style: TextStyle(color: Colors.redAccent),),
        )
      ],
    );
  }

}
