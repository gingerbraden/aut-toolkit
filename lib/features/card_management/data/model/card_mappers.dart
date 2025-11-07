import 'dart:convert';

import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

extension UserCardEntityMapper on UserCardEntity {
  UserCard toModel() => UserCard(
    id: id,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    names: Map<String,String>.from(jsonDecode(namesJson)),
  );
}

extension UserCardMapper on UserCard {
  UserCardEntity toEntity() => UserCardEntity(
    id: id ?? 0,
    arasaacId: arasaacId,
    userId: userId,
    localImgPath: localImgPath,
    namesJson: jsonEncode(names),
  );
}
