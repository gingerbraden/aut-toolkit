import 'dart:io';

import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/router_utils.dart';
import '../../../../../i18n/strings.g.dart';
import '../../domain/model/first_then_board.dart';
import '../viewmodel/first_then_board_list_viewmodel.dart';

class FirstThenBoardList extends ConsumerStatefulWidget {
  const FirstThenBoardList({super.key});

  @override
  ConsumerState<FirstThenBoardList> createState() =>
      _FirstThenBoardListViewState();
}

class _FirstThenBoardListViewState extends ConsumerState<FirstThenBoardList> {
  final TextEditingController _searchController = TextEditingController();

  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseService().currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final boards = ref.watch(firstThenBoardViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text(t.first_then_boards)),
      body: Padding(
        padding: EdgeInsets.only(
          left: AppConstants.BASE_APP_UI_PADDING,
          right: AppConstants.BASE_APP_UI_PADDING,
          bottom: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: Column(
          children: [
            _searchField(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Divider(),
            ),
            Expanded(
              child: boards.isEmpty
                  ? Center(child: Text(t.no_entries))
                  : _gridView(boards),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBoard,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (v) {
        ref.read(firstThenBoardViewModelProvider(userId).notifier).search(v);
      },
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

  Widget _gridView(List<FirstThenBoard> boards) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const minWidth = 260.0;
        int columns = (constraints.maxWidth / minWidth).floor().clamp(2, 6);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 1.2,
          ),
          itemCount: boards.length,
          itemBuilder: (_, i) => _gridTile(boards[i]),
        );
      },
    );
  }

  Widget _gridTile(FirstThenBoard board) {
    return InkWell(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image(board.first.localImgPath),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                  const SizedBox(width: 8),
                  _image(board.then.localImgPath),
                ],
              ),

              const SizedBox(height: 8),

              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.BASE_APP_UI_PADDING,
                  ),
                  child: Text(
                    board.name,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    router.push(RouterUtils.getFirstThenBoardShowPath(), extra: board);
                  }, icon: Icon(Icons.play_circle)),
                  IconButton(onPressed: () {router.push(RouterUtils.getNewFirstThenBoardPath(), extra: board);}, icon: Icon(Icons.edit)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(path),
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 56,
          height: 56,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

  void _createNewBoard() {
    final docRef = FirebaseFirestore.instance
        .collection('first_then_boards')
        .doc();
    router.push(
      RouterUtils.getNewFirstThenBoardPath(),
      extra: FirstThenBoard(
        remoteId: docRef.id,
        name: '',
        userId: userId,
        first: UserCard(
          userId: userId,
          localImgPath: "",
          names: {},
          updatedAt: DateTime.now(),
          remoteImgPath: "",
        ),
        then: UserCard(
          userId: userId,
          localImgPath: "",
          names: {},
          updatedAt: DateTime.now(),
          remoteImgPath: "",
        ),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
