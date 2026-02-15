import 'dart:io';

import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:flutter/material.dart';

class KeyboardTileContent extends StatelessWidget {
  final String name;
  final UserCard cover;

  const KeyboardTileContent({
    super.key,
    required this.name,
    required this.cover,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).dividerColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final tabW = w * 0.5;
        final tabH = h * 0.14;

        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(cover.localImgPath),
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.broken_image_outlined,
                              size: 36,
                              color: borderColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: tabW,
                height: tabH,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: borderColor),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
