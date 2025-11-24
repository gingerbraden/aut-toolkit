import 'dart:io';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../card_management/domain/model/user_card.dart';
import '../../../../card_management/provider/card_notifier.dart';
import '../../domain/model/visual_list.dart';

class VisualListDiagramShow extends ConsumerStatefulWidget {
  final VisualList visualList;

  const VisualListDiagramShow({super.key, required this.visualList});

  @override
  _VisualListDiagramShowState createState() => _VisualListDiagramShowState();
}

class _VisualListDiagramShowState extends ConsumerState<VisualListDiagramShow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCards = ref.watch(cardsProvider);

    final steps = widget.visualList.steps
        .map(
          (card) =>
              allCards.firstWhere((c) => c.id == card.id, orElse: () => card),
        )
        .toList();

    Widget buildStep(UserCard card) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card.names[LocaleSettings.currentLocale.languageCode] ?? '',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (card.localImgPath.isNotEmpty)
                _image(context, card.localImgPath, 0.18),
            ],
          ),
        ),
      );
    }

    List<Widget> buildStepsWithArrows() {
      List<Widget> children = [];
      for (int i = 0; i < steps.length; i++) {
        children.add(buildStep(steps[i]));

        if (i != steps.length - 1) {
          children.add(
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.arrow_forward, size: 50),
            ),
          );
        }
      }
      return children;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.visualList.name)),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildStepsWithArrows(),
          ),
        ),
      ),
    );
  }

  Widget _image(BuildContext context, String path, double sizeScale) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: screenWidth * sizeScale,
        height: screenWidth * sizeScale,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 40),
          ),
        ),
      ),
    );
  }
}
