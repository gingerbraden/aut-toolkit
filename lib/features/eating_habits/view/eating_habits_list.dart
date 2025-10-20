import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/widgets/active_icon.dart';
import 'package:aut_toolkit/core/widgets/eating_icon.dart';
import 'package:aut_toolkit/core/widgets/sized_box_divider.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/provider/eating_habits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_util.dart';
import '../../../core/utils/router_utils.dart';
import '../../../i18n/strings.g.dart';

class EatingHabitsList extends ConsumerStatefulWidget {
  const EatingHabitsList({super.key});

  @override
  ConsumerState<EatingHabitsList> createState() => _EatingHabitsListState();
}

class _EatingHabitsListState extends ConsumerState<EatingHabitsList> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    AppConstants.IS_EATING,
    AppConstants.IS_NOT_EATING,
    AppConstants.IS_ACTIVE,
    AppConstants.IS_NOT_ACTIVE,
  ];
  List<String> _selectedFilters = [];
  String _searchQuery = '';
  String _selectedSort = AppConstants.NAME_ASC;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(eatingHabitsProvider);
    final filteredHabits = _checkFiltersAndSort(habits);

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
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _searchTextField(),
                const SizedBox(width: 8), // spacing between textfield and icon
                _filterButton(),
              ],
            ),
            const SizedBoxDivider(),
            _selectedFiltersShow(),
            const SizedBox(height: 4,),
            _listOfHabits(filteredHabits)
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(RouterUtils.getNewEatingHabitPath(), extra: new EatingHabit(from: DateTime.now(), to: null, isEatingFlag: true, name: '', description: '', userId: FirebaseService().currentUser!.uid));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _searchTextField() {
    return Expanded(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: t.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _filterButton() {
    return SizedBox(
      height: 48, // optional: match TextField height
      width: 48,  // square button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _openFilterDialog,
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _selectedFiltersShow() {
    return Wrap(
      spacing: 8.0,
      children: _selectedFilters.map((filter) {
        final isSelected = _selectedFilters.contains(filter);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getIcon(filter),
              SizedBoxDivider(),
              Text(AppConstants.getLabel(filter)),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedFilters.remove(filter);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _listOfHabits(List<EatingHabit> filteredHabits) {
    return Expanded(
      child: filteredHabits.isEmpty
          ? Center(child: Text(t.no_entries))
          : ListView.builder(
        itemCount: filteredHabits.length,
        itemBuilder: (context, index) {
          final habit = filteredHabits[index];
          return Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                router.push(RouterUtils.getEatingHabitDetailPath(), extra: habit);
              },
              child: ListTile(
                  title: Text(habit.name),
                  subtitle: Text(
                    '${t.from} ${DateUtil.returnDateInStringFormat(habit.from)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EatingIcon(isEatingFlag: habit.isEatingFlag),
                      ActiveIcon(isActiveFlag: DateUtil.isTodayBetweenTwoDates(habit.from, habit.to))
                    ],
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        List<String> tempSelectedFilters = List.from(_selectedFilters);
        String tempSort = _selectedSort;

        List<String> combinedSortOptions = [
          AppConstants.NAME_ASC,
          AppConstants.NAME_DESC,
          AppConstants.DATE_ASC,
          AppConstants.DATE_DESC,
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(t.filters_and_sorting),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(t.sort_by, style: Theme.of(context).textTheme.titleMedium,),
                        const SizedBoxDivider(),
                        DropdownButton<String>(
                          value: tempSort,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tempSort = value;
                              });
                            }
                          },
                          items: combinedSortOptions
                              .map((sortOption) => DropdownMenuItem(
                            value: sortOption,
                            child: Text(AppConstants.getLabel(sortOption)),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    SizedBoxDivider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        children: _filters.map((filter) {
                          final isSelected = tempSelectedFilters.contains(filter);
                          return FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _getIcon(filter),
                                SizedBoxDivider(),
                                Text(AppConstants.getLabel(filter)),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  tempSelectedFilters.add(filter);
                                } else {
                                  tempSelectedFilters.remove(filter);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'filters': tempSelectedFilters,
                      'sort': tempSort,
                    });
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedFilters = result['filters'];
        _selectedSort = result['sort'];
      });
    }
  }

  List<EatingHabit> _checkFiltersAndSort(List<EatingHabit> habits) {

    // Filter
    List<EatingHabit> filtered = habits.where((habit) {
      final matchesSearch =
      habit.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter = true;

      if (_selectedFilters.isNotEmpty) {
        matchesFilter = false;

        if (_selectedFilters.contains(AppConstants.IS_EATING) && habit.isEatingFlag == true) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(AppConstants.IS_NOT_EATING) && habit.isEatingFlag == false) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(AppConstants.IS_ACTIVE) &&
            (habit.to == null || habit.to!.isAfter(DateTime.now()))) {
          matchesFilter = true;
        } else if (_selectedFilters.contains(AppConstants.IS_NOT_ACTIVE) &&
            (habit.to != null && habit.to!.isBefore(DateTime.now()))) {
          matchesFilter = true;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();

    // Sort
    switch (_selectedSort) {
      case AppConstants.NAME_ASC:
        filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); // A → Z
        break;
      case AppConstants.NAME_DESC:
        filtered.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase())); // Z → A
        break;
      case AppConstants.DATE_DESC:
        filtered.sort((a, b) {
          final dateA = a.to ?? DateTime(1970);
          final dateB = b.to ?? DateTime(1970);
          return dateA.compareTo(dateB); // Oldest first
        });
        break;
      case AppConstants.DATE_ASC:
        filtered.sort((a, b) {
          final dateA = a.to ?? DateTime(1970);
          final dateB = b.to ?? DateTime(1970);
          return dateB.compareTo(dateA); // Newest first
        });
        break;
    }

    return filtered;
  }

  Widget _getIcon(String code) {
    switch(code) {
      case AppConstants.IS_EATING:
        return EatingIcon(isEatingFlag: true);
      case AppConstants.IS_NOT_EATING:
        return EatingIcon(isEatingFlag: false);
      case AppConstants.IS_ACTIVE:
        return ActiveIcon(isActiveFlag: true);
      case AppConstants.IS_NOT_ACTIVE:
        return ActiveIcon(isActiveFlag: false);
    }
    return SizedBoxDivider();
  }

}
