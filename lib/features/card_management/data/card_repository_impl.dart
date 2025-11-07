import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_local_source.dart';

import '../domain/model/user_card.dart';
import '../domain/repository/card_repository.dart';

class CardRepositoryImpl implements CardRepository {
  final CardLocalSource _localSource;

  CardRepositoryImpl(this._localSource);

  @override
  List<UserCard> getAllCards() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveCard(UserCard card) {
    _localSource.put(card.toEntity());
  }

  @override
  void deleteCard(UserCard card) {
    ImageUtil.deleteImage(card.localImgPath);
    _localSource.remove(card.id!);
  }
}
