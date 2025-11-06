import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_local_source.dart';

import '../domain/model/card.dart';
import '../domain/repository/card_repository.dart';

class CardRepositoryImpl implements CardRepository {
  final CardLocalSource _localSource;

  CardRepositoryImpl(this._localSource);

  @override
  List<Card> getAllCards() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveCard(Card card) {
    _localSource.put(card.toEntity());
  }

  @override
  void deleteCard(Card card) {
    ImageUtil.deleteImage(card.localImgPath);
    _localSource.remove(card.id!);
  }
}
