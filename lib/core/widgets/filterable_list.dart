import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';

class FilterOption<T> {
  final String code;
  final String label;
  final bool Function(T item) predicate;
  final Widget? icon;

  FilterOption({
    required this.code,
    required this.label,
    required this.predicate,
    this.icon,
  });
}

class SortOption<T> {
  final String code;
  final String label;
  final int Function(T a, T b) comparator;

  SortOption({
    required this.code,
    required this.label,
    required this.comparator,
  });
}

class FilterableList<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T item) searchKey;
  final Widget Function(T item) itemBuilder;
  final List<FilterOption<T>> filters;
  final List<SortOption<T>> sorts;
  final void Function(T item)? onTap;
  final Widget? floatingActionButton;

  const FilterableList({
    super.key,
    required this.title,
    required this.items,
    required this.searchKey,
    required this.itemBuilder,
    required this.filters,
    required this.sorts,
    this.onTap,
    this.floatingActionButton,
  });


  @override
  State<FilterableList<T>> createState() => _FilterableListState<T>();
}

class _FilterableListState<T> extends State<FilterableList<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedFilters = [];
  late SortOption<T> _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.sorts.first;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _applyFiltersAndSort();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _searchField()),
                const SizedBox(width: 8),
                _filterButton(),
              ],
            ),
            _selectedFiltersChips(),
            Padding(
              padding: _selectedFilters.isEmpty ? EdgeInsets.symmetric(vertical: 8) : EdgeInsets.symmetric(vertical: 0),
              child: Divider(),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text("No entries"))
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (_, i) {
                  final item = filteredItems[i];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onTap?.call(item),
                      child: widget.itemBuilder(item),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );

  }

  Widget _searchField() => TextField(
    controller: _searchController,
    onChanged: (v) => setState(() => _searchQuery = v),
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.search),
      hintText: 'Search...',
      border: OutlineInputBorder(),
    ),
  );

  Widget _filterButton() => IconButton(
    icon: const Icon(Icons.filter_list),
    onPressed: _openFilterDialog,
  );

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        List<String> tempSelected = List.from(_selectedFilters);
        SortOption<T> tempSort = _selectedSort;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0), // smaller title padding
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 16, 8), // smaller internal padding
            title: Text(t.filters_and_sorting),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // align children to left
                children: [
                  DropdownButton<String>(
                    value: tempSort.code,
                    isExpanded: true, // make dropdown take full width
                    items: widget.sorts
                        .map((sort) => DropdownMenuItem<String>(
                      value: sort.code,
                      child: Text(sort.label),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tempSort = widget.sorts.firstWhere((s) => s.code == value);
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: widget.filters.map((f) {
                      final selected = tempSelected.contains(f.code);
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (f.icon != null) f.icon!,
                            if (f.icon != null) const SizedBox(width: 4),
                            Text(f.label),
                          ],
                        ),
                        selected: selected,
                        onSelected: (s) => setState(() {
                          s ? tempSelected.add(f.code) : tempSelected.remove(f.code);
                        }),
                      );
                    }).toList(),
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
                onPressed: () => Navigator.pop(context, {
                  'filters': tempSelected,
                  'sort': tempSort,
                }),
                child: Text(t.save),
              ),
            ],
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        _selectedFilters = result['filters'];
        _selectedSort = result['sort'];
      });
    }
  }


  List<T> _applyFiltersAndSort() {
    var filtered = widget.items.where((item) {
      final matchesSearch =
      widget.searchKey(item).toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilters = _selectedFilters.every((code) =>
          widget.filters.firstWhere((f) => f.code == code).predicate(item));

      return matchesSearch && matchesFilters;
    }).toList();

    filtered.sort(_selectedSort.comparator);
    return filtered;
  }

  Widget _selectedFiltersChips() {
    if (_selectedFilters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _selectedFilters.map((code) {
            final filter = widget.filters.firstWhere((f) => f.code == code);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.icon != null) filter.icon!,
                  const SizedBox(width: 4),
                  Text(filter.label),
                ],
              ),
              selected: true,
              onSelected: (_) {
                setState(() {
                  _selectedFilters.remove(code);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }



}
