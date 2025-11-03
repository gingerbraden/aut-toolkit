import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class SquareImageFilledWidth extends StatelessWidget {
  const SquareImageFilledWidth({super.key, this.imageFilePath});

  final String? imageFilePath;

  @override
  Widget build(BuildContext context) {
    final path = imageFilePath;
    if (path == null || path.isEmpty) {
      return const SizedBox.shrink();
    }

    final file = File(path);
    if (!file.existsSync()) {
      return const Text("⚠️ Image not found");
    }

    final screenWidth =
        MediaQuery.of(context).size.width -
        (AppConstants.BASE_APP_UI_PADDING * 2);
    return Container(
      width: screenWidth,
      height: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
          );
        },
      ),
    );
  }
}
