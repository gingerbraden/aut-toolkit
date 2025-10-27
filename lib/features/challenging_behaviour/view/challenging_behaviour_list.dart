import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/occuring_icon.dart';
import 'package:aut_toolkit/core/widgets/sized_box_divider.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_util.dart';
import '../../../i18n/strings.g.dart';

class ChallengingBehaviourList extends ConsumerStatefulWidget {
  const ChallengingBehaviourList({super.key});

  @override
  ConsumerState<ChallengingBehaviourList> createState() =>
      _ChallengingBehaviourListState();
}

class _ChallengingBehaviourListState
    extends ConsumerState<ChallengingBehaviourList> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
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
    final habits = ref.watch(challengingBehavioursProvider);
    final filteredHabits = _checkFiltersAndSort(habits);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            router.pop();
          },
        ),
        title: Text(t.challenging_behaviour),
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
                const SizedBox(width: 8),
                _filterButton(),
              ],
            ),
            const SizedBoxDivider(),
            _selectedFiltersShow(),
            const SizedBox(height: 4),
            _listOfHabits(filteredHabits),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(RouterUtils.getNewChallengingBehaviourPath(), extra: ChallengingBehaviour(name: "", from: DateTime.now(), generalDescription: "", diaryEntries: [], occuring: true, userId: FirebaseService().currentUser!.uid));
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),
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
      height: 48,
      width: 48,
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

  Widget _listOfHabits(List<ChallengingBehaviour> filteredCb) {
    return Expanded(
      child: filteredCb.isEmpty
          ? Center(child: Text(t.no_entries))
          : ListView.builder(
              itemCount: filteredCb.length,
              itemBuilder: (context, index) {
                final cb = filteredCb[index];
                return Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () {
                      router.push(RouterUtils.getChallengingBehaviourDetailPath(), extra: cb);
                    },
                    title: Text(cb.name),
                    subtitle: Text(
                      '${t.from} ${DateUtil.returnDateInStringFormat(cb.from)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [OccuringIcon(isOccuringFlag: cb.occuring)],
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
                        Text(
                          t.sort_by,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                              .map(
                                (sortOption) => DropdownMenuItem(
                                  value: sortOption,
                                  child: Text(
                                    AppConstants.getLabel(sortOption),
                                  ),
                                ),
                              )
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
                          final isSelected = tempSelectedFilters.contains(
                            filter,
                          );
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
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'filters': tempSelectedFilters,
                      'sort': tempSort,
                    });
                  },
                  child: Text(t.save),
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

  List<ChallengingBehaviour> _checkFiltersAndSort(
    List<ChallengingBehaviour> cbs,
  ) {
    // Filter
    List<ChallengingBehaviour> filtered = cbs.where((cb) {
      final matchesSearch = cb.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      bool matchesFilter = true;

      if (_selectedFilters.isNotEmpty) {
        if (_selectedFilters.contains(AppConstants.IS_ACTIVE) &&
            !(cb.from.isAfter(DateTime.now()))) {
          matchesFilter = false;
        }

        if (_selectedFilters.contains(AppConstants.IS_NOT_ACTIVE) &&
            !(cb.from.isBefore(DateTime.now()))) {
          matchesFilter = false;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();

    // Sort
    switch (_selectedSort) {
      case AppConstants.NAME_ASC:
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case AppConstants.NAME_DESC:
        filtered.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case AppConstants.DATE_ASC:
        filtered.sort((a, b) {
          return a.from.compareTo(b.from);
        });
        break;
      case AppConstants.DATE_DESC:
        filtered.sort((a, b) {
          return b.from.compareTo(a.from);
        });
        break;
    }

    return filtered;
  }

  Widget _getIcon(String code) {
    switch (code) {
      case AppConstants.IS_ACTIVE:
        return OccuringIcon(isOccuringFlag: true);
      case AppConstants.IS_NOT_ACTIVE:
        return OccuringIcon(isOccuringFlag: false);
    }
    return SizedBoxDivider();
  }
}
