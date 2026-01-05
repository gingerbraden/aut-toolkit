import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';
import '../../selected_person/domain/model/selected_person.dart';

class SelectedPersonManagementTile extends ConsumerStatefulWidget {
  const SelectedPersonManagementTile({super.key});

  @override
  ConsumerState<SelectedPersonManagementTile> createState() =>
      _SelectedPersonManagementTileState();
}

class _SelectedPersonManagementTileState
    extends ConsumerState<SelectedPersonManagementTile> {
  @override
  Widget build(BuildContext context) {
    final allPersons = ref.watch(selectedPersonsProvider);

    return ListTile(
      leading: const Icon(Icons.person_2),
      title: Text(t.managed_people),
      subtitle: Text('${allPersons.length}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showSelectedPeopleDialog(context),
    );
  }

  void _showSelectedPeopleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final people = ref.watch(selectedPersonsProvider);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(t.managed_people),
              content: SizedBox(
                width: double.maxFinite,
                child: people.isEmpty
                    ? Text(t.no_entries)
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    final person = people[index];

                    return ListTile(
                      title: Text(person.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditPersonDialog(context, ref, person),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmAndDelete(context, ref, person),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmAndDelete(
      BuildContext context, WidgetRef ref, SelectedPerson person) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${t.delete} ${person.name}?'),
        content: Text(t.cant_undo_action),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(selectedPersonsProvider.notifier).delete(person);
    }
  }

  Future<void> _showEditPersonDialog(
      BuildContext context, WidgetRef ref, SelectedPerson person) async {
    final controller = TextEditingController(text: person.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${t.edit} ${person.name}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: t.name),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(t.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != person.name) {
      person.name = newName;
      ref.read(selectedPersonsProvider.notifier).add(person);
    }
  }
}

