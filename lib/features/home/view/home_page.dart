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
      appBar: AppBar(
        title: Text(t.home),
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedPersonArea(allPersons),
              Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                child: Divider(),
              ),
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
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                child: Divider(),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 125,
                      child: _buildCard(
                        t.visual_supports,
                        "",
                        RouterUtils.getVisualSupportsPagePath(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 125,
                      child: _buildCard(
                        t.cards,
                        "",
                        RouterUtils.getCardsPath(),
                      ),
                    ),
                  ),
                ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (subtitle.isNotEmpty)
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
    final selected = allPersons.isEmpty
        ? null
        : allPersons.firstWhere(
            (sp) => sp.isSelected,
            orElse: () => allPersons.first,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DropdownButtonFormField<SelectedPerson>(
                  initialValue: selected,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: [
                    ...allPersons.map((person) {
                      return DropdownMenuItem<SelectedPerson>(
                        value: person,
                        child: Text(
                          person.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    }).toList(),
                    DropdownMenuItem<SelectedPerson>(
                      value: null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.add_managed_person,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (person) {
                    if (person == null) {
                      _showCreatePersonDialog(false);
                    } else {
                      ref.read(selectedPersonsProvider.notifier).add(person);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
