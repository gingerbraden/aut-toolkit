import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/provider/eating_habits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_util.dart';
import '../../../i18n/strings.g.dart';

class EatingHabitsList extends ConsumerStatefulWidget {
  const EatingHabitsList({super.key});

  @override
  ConsumerState<EatingHabitsList> createState() => _EatingHabitsListState();
}

class _EatingHabitsListState extends ConsumerState<EatingHabitsList> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    t.is_eating,
    t.is_not_eating,
    t.active,
    t.inactive,
  ];
  final List<String> _selectedFilters = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(eatingHabitsProvider);

    final filteredHabits = _checkFilters(habits);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            router.pop();
          },
        ),
        title: Text(t.eating_habits),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: t.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8.0,
              children: _filters.map((filter) {
                final isSelected = _selectedFilters.contains(filter);
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(filter);
                      } else {
                        _selectedFilters.remove(filter);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: filteredHabits.isEmpty
                  ? Center(child: Text(t.no_entries))
                  : ListView.builder(
                      itemCount: filteredHabits.length,
                      itemBuilder: (context, index) {
                        final habit = filteredHabits[index];
                        return Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(habit.name),
                            subtitle: Text(
                              '${t.from} ${DateUtil().returnDateInStringFormat(habit.from)}',
                            ),
                            trailing: Icon(
                              habit.isEatingFlag == true
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: habit.isEatingFlag == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          habits.add(EatingHabit(from: DateTime.timestamp(),
              to: null,
              isEatingFlag: true,
              name: "ok",
              description: "o"));
          setState(() {

          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<EatingHabit> _checkFilters(List<EatingHabit> habits) {
    return habits.where((habit) {
      final matchesSearch =
      habit.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter = true;

      if (_selectedFilters.isNotEmpty) {
        matchesFilter = false;

        if (_selectedFilters.contains(t.is_eating) &&
            habit.isEatingFlag == true) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(t.is_not_eating) &&
            habit.isEatingFlag == false) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(t.active) &&
            (habit.to == null || habit.to!.isAfter(DateTime.now()))) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(t.inactive) &&
            (habit.to != null && habit.to!.isBefore(DateTime.now()))) {
          matchesFilter = true;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }
}
