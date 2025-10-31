import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';
import '../../selected_person/domain/model/selected_person.dart';

class SelectedPersonManagementTile extends ConsumerStatefulWidget {
  const SelectedPersonManagementTile({super.key});

  @override
  ConsumerState<SelectedPersonManagementTile> createState() => _SelectedPersonManagementTileState();
}

class _SelectedPersonManagementTileState extends ConsumerState<SelectedPersonManagementTile> {
  @override
  Widget build(BuildContext context) {
    final allPersons = ref.watch(selectedPersonsProvider);

    return ListTile(
      leading: const Icon(CupertinoIcons.person_2),
      title: Text(t.managed_people),
      subtitle: Text('${allPersons.length}'),
      trailing: const Icon(CupertinoIcons.chevron_right),
      onTap: () => _showSelectedPeopleDialog(context, allPersons),
    );
  }

  void _showSelectedPeopleDialog(
      BuildContext context, List<SelectedPerson> people) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  leading: const Icon(Icons.person),
                  title: Text(person.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {

                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("${t.really_delete_object}${person.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(t.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(t.yes, style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        ref
                            .read(selectedPersonsProvider.notifier)
                            .delete(person);
                        Navigator.of(context).pop();
                        _showSelectedPeopleDialog(
                            context, ref.read(selectedPersonsProvider));
                      }
                    },
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
  }
  
}
