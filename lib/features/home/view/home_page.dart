import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/selected_person/domain/model/selected_person.dart';
import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../i18n/strings.g.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    // Wait until the first frame to access ref safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final allPersons = ref.read(selectedPersonsProvider);

      if (allPersons.isEmpty) {
        _showCreatePersonDialog(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPersons = ref.watch(selectedPersonsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.home), elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedPersonArea(allPersons),
              Padding(padding: const EdgeInsets.all(8.0), child: Divider()),
              const SizedBox(height: 8),
              _buildCard(
                t.eating_habits,
                t.eating_habits_desc,
                RouterUtils.getEatingHabitsPath(),
              ),
              const SizedBox(height: 8),
              _buildCard(
                t.challenging_behaviour,
                t.challenging_behaviour_desc,
                RouterUtils.getChallengingBehavioursPath(),
              ),
              const SizedBox(height: 8),
              _buildCard(
                t.good_habits,
                t.good_habits_desc,
                RouterUtils.getGoodHabitsPath(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePersonDialog(bool isFirst) {
    showDialog(
      context: context,
      barrierDismissible: !isFirst,
      builder: (context) {
        String name = '';
        return AlertDialog(
          title: Text(t.add_managed_person),
          content: TextField(
            onChanged: (value) => name = value,
            decoration: InputDecoration(hintText: t.create),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  final newPerson = SelectedPerson(
                    userId: FirebaseService().currentUser!.uid,
                    name: name,
                    isSelected: false,
                  );

                  ref.read(selectedPersonsProvider.notifier).add(newPerson);

                  Navigator.of(context).pop();
                }
              },
              child: Text(t.create),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(String title, String subtitle, String route) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        router.push(route);
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            softWrap: true,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Theme.of(
                            context,
                          ).textTheme.headlineMedium!.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedPersonArea(List<SelectedPerson> allPersons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButton<SelectedPerson>(
              value: allPersons.isEmpty
                  ? null
                  : allPersons.firstWhere((sp) => sp.isSelected),
              isExpanded: true,
              underline: const SizedBox(),
              items: allPersons.map((person) {
                return DropdownMenuItem<SelectedPerson>(
                  value: person,
                  child: Text(
                    person.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                );
              }).toList(),
              onChanged: (person) {
                if (person != null) {
                  ref.read(selectedPersonsProvider.notifier).add(person);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showCreatePersonDialog(false);
            },
          ),
        ],
      ),
    );
  }
}
