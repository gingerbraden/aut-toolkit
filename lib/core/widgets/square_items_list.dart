import 'package:flutter/material.dart';
import '../../i18n/strings.g.dart';
import '../constants/app_constants.dart';

class SquareItemsList<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T item) searchKey;
  final Widget Function(T item) itemBuilder;
  final void Function(T item)? onTap;
  final Widget? floatingActionButton;

  const SquareItemsList({
    super.key,
    required this.title,
    required this.items,
    required this.searchKey,
    required this.itemBuilder,
    this.onTap,
    this.floatingActionButton,
  });

  @override
  State<SquareItemsList<T>> createState() => _GridListState<T>();
}

class _GridListState<T> extends State<SquareItemsList<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _applySearch();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          children: [
            _searchField(),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 4,
                left: 10,
                right: 10,
              ),
              child: Divider(),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(child: Text(t.no_entries))
                  : LayoutBuilder(
                builder: (context, constraints) {
                  const double minItemWidth = 160;
                  final int crossAxisCount =
                  (constraints.maxWidth / minItemWidth).floor().clamp(3, 8);

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, i) {
                      final item = filteredItems[i];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => widget.onTap?.call(item),
                          borderRadius: BorderRadius.circular(16),
                          child: widget.itemBuilder(item),
                        ),
                      );
                    },
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
    style: const TextStyle(fontSize: 16),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: t.search,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(99),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    ),
  );

  List<T> _applySearch() {
    return widget.items
        .where((item) =>
        widget.searchKey(item).toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
}
