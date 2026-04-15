import 'dart:io';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import '../../../card_management/domain/model/user_card.dart';

class CardTileContent extends StatelessWidget {
  final UserCard card;

  const CardTileContent({required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(card.localImgPath),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          card.names[LocaleSettings.currentLocale.languageCode]!,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
