import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/router_utils.dart';
import '../../../../../i18n/strings.g.dart';
import '../../domain/model/visual_list.dart';
import '../../provider/visual_list_notifier.dart';

class VisualListList extends ConsumerStatefulWidget {
  final bool isDiagram;

  const VisualListList({super.key, required this.isDiagram});

  @override
  ConsumerState<VisualListList> createState() => _VisualListScreenState();
}

class _VisualListScreenState extends ConsumerState<VisualListList> {
  late final String userId;
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void initState() {
    super.initState();
    userId = FirebaseService().currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.isDiagram
        ? visualDiagramsProvider(userId)
        : visualSchedulesProvider(userId);

    final lists = ref.watch(provider);

    final filtered = _query.isEmpty
        ? lists
        : lists
              .where((v) => v.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDiagram ? t.visual_diagrams : t.visual_schedules),
      ),

      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          children: [
            _searchField(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Divider(),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(t.no_entries))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        return _tile(item);
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewList(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: t.search,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _tile(VisualList list) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(list.name),
        subtitle: Text("${list.steps.length} ${t.steps(n: list.steps.length)}"),
        onTap: () {
          if (widget.isDiagram) {
            router.push(
              RouterUtils.getVisualListDiagramShowPath(),
              extra: list,
            );
          }
        },
        onLongPress: () {
          router.push(RouterUtils.getNewVisualListPath(), extra: list);
        },
      ),
    );
  }

  void _createNewList() {
    router.push(
      RouterUtils.getNewVisualListPath(),
      extra: VisualList(
        userId: userId,
        name: "",
        steps: [],
        isVisualSchedule: !widget.isDiagram,
        isVisualDiagram: widget.isDiagram,
      ),
    );
  }
}
