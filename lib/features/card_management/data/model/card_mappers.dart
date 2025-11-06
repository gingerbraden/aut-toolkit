import 'dart:convert';

import 'package:aut_toolkit/features/card_management/data/model/card_entity.dart';
import 'package:aut_toolkit/features/card_management/domain/model/card.dart';

extension CardEntityMapper on CardEntity {
  Card toModel() => Card(
    id: id,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    names: Map<String,String>.from(jsonDecode(namesJson)),
  );
}

extension CardMapper on Card {
  CardEntity toEntity() => CardEntity(
    id: id ?? 0,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    namesJson: jsonEncode(names),
  );
}
