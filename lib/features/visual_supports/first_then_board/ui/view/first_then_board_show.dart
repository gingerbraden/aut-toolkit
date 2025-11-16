import 'dart:io';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/first_then_board.dart';

class FirstThenBoardShow extends ConsumerStatefulWidget {
  final FirstThenBoard board;

  const FirstThenBoardShow({super.key, required this.board});

  @override
  ConsumerState<FirstThenBoardShow> createState() => _FirstThenBoardShowState();
}

class _FirstThenBoardShowState extends ConsumerState<FirstThenBoardShow> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;

    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    Widget buildCard(UserCard card, String text) {
      if (isPortrait) {
        return Column(
          children: [
            Text(text, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _image(card.localImgPath, 0.65),
          ],
        );
      } else {
        return Column(
          children: [
            Text(text, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(child: _image(card.localImgPath, 0.25)),
          ],
        );
      }
    }

    return Scaffold(
      appBar: isPortrait ? AppBar(title: Text(board.name), forceMaterialTransparency: true,) : null,
      body: isPortrait
          ? SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(left: AppConstants.BASE_APP_UI_PADDING, right: AppConstants.BASE_APP_UI_PADDING, bottom: AppConstants.BASE_APP_UI_PADDING),
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          buildCard(board.first, t.first),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(thickness: 5,),
                          ),
                          buildCard(board.then, t.then),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          )
          : Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING*2),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
                  child: Row(
                    children: [
                      Expanded(child: buildCard(board.first, t.first)),
                      VerticalDivider(thickness: 5,),
                      Expanded(child: buildCard(board.then, t.then)),
                    ],
                  ),
                ),
            ),
          ),
    );
  }

  Widget _image(String path, double sizeScale) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: screenWidth * sizeScale,
        height: screenWidth * sizeScale,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}
