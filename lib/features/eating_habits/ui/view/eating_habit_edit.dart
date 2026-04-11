import 'package:aut_toolkit/core/widgets/info_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/image_util.dart';
import '../../../../core/widgets/divider/sized_box_divider.dart';
import '../../../../core/widgets/icon/eating_icon.dart';
import '../../../../core/widgets/square_image_filled_width.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/model/eating_habit.dart';
import '../viewmodel/eating_habit_edit_viewmodel.dart';

class EatingHabitEdit extends ConsumerWidget {
  final EatingHabit habit;
  final bool isNew;

  const EatingHabitEdit({super.key, required this.habit, required this.isNew});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eatingHabitViewModelProvider(habit));
    final viewModel = ref.read(eatingHabitViewModelProvider(habit).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? t.create : t.edit),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              if (_validateForm(ref)) {
                viewModel.saveChanges(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.change_saved),
                    behavior: SnackBarBehavior.floating,
                    showCloseIcon: true,
                  ),
                );
                router.pop();
                if (!isNew) router.pop();
              }
            },
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
            child: Column(
              children: [
                _nameTextField(state, viewModel),
                const SizedBox(height: 8),
                _dateFields(state, viewModel, context),
                InfoSmallText(description: t.from_to_info),
                const SizedBox(height: 8),

                const Divider(),
                _isEatingRadioButtons(state, viewModel),
                const SizedBox(height: 8),

                InfoSmallText(description: t.is_eating_info),
                const SizedBox(height: 8),
                const Divider(),

                SizedBoxDivider(),
                _descriptionTextField(state, viewModel),
                SizedBoxDivider(),
                _imageButtons(state, viewModel, context),
                SizedBoxDivider(),
                InfoSmallText(description: t.eating_habit_photo_info),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm(WidgetRef ref) {
    final state = ref.read(eatingHabitViewModelProvider(habit));
    return state.name.isNotEmpty;
  }

  Widget _nameTextField(
    EatingHabitFormState state,
    EatingHabitEditViewModel viewModel,
  ) {
    return TextFormField(
      initialValue: state.name,
      decoration: InputDecoration(
        labelText: t.eating_habit_name,
        border: const OutlineInputBorder(),
      ),
      onChanged: viewModel.updateName,
    );
  }

  Widget _descriptionTextField(
    EatingHabitFormState state,
    EatingHabitEditViewModel viewModel,
  ) {
    return TextFormField(
      initialValue: state.description,
      decoration: InputDecoration(
        labelText: t.notes,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
      maxLines: 7,
      onChanged: viewModel.updateDescription,
    );
  }

  Widget _dateFields(
    EatingHabitFormState state,
    EatingHabitEditViewModel viewModel,
    BuildContext context,
  ) {
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
            onTap: () => _pickDate(context, true, viewModel, state.fromDate),
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
            onTap: () => _pickDate(context, false, viewModel, state.toDate),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    bool isFrom,
    EatingHabitEditViewModel viewModel,
    DateTime? initial,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;

    if (isFrom) {
      viewModel.updateFromDate(newDate);
    } else {
      viewModel.updateToDate(newDate);
    }
  }

  Widget _isEatingRadioButtons(
    EatingHabitFormState state,
    EatingHabitEditViewModel viewModel,
  ) {
    return RadioGroup<EatingStatus>(
      groupValue: state.status,
      onChanged: (EatingStatus? value) {
        if (value != null) viewModel.updateStatus(value);
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
            ),
          ),
          RadioListTile(
            value: EatingStatus.notEating,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                EatingIcon(isEatingFlag: false),
                SizedBoxDivider(),
                Text(t.is_not_eating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageButtons(
    EatingHabitFormState state,
    EatingHabitEditViewModel viewModel,
    BuildContext context,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: state.imagePath == null || state.imagePath!.isEmpty
          ? ElevatedButton.icon(
              key: const ValueKey('add_image'),
              onPressed: () => _pickImage(context, viewModel, state.imagePath),
              icon: const Icon(Icons.add_a_photo),
              label: Text(t.load_image),
            )
          : Column(
              key: const ValueKey('edit_delete_image'),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          _pickImage(context, viewModel, state.imagePath),
                      icon: const Icon(Icons.edit),
                      label: Text(t.change_image),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (state.imagePath != null &&
                            state.imagePath!.isNotEmpty) {
                          ImageUtil.deleteImage(state.imagePath!);
                          viewModel.updateImage('');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.image_deleted),
                              behavior: SnackBarBehavior.floating,
                              showCloseIcon: true,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      label: Text(
                        t.delete_image,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
                SizedBoxDivider(),
                SquareImageFilledWidth(imageFilePath: state.imagePath!),
              ],
            ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    EatingHabitEditViewModel viewModel,
    String? oldPath,
  ) async {
    final imgPath = await ImageUtil.pickAndStoreImage(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).textTheme.headlineLarge!.color!,
    );

    if (imgPath != null) {
      if (oldPath != null) {
        ImageUtil.deleteImage(oldPath);
      }
      viewModel.updateImage(imgPath);
    }
  }
}
