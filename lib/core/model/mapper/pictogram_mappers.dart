import '../Pictogram.dart';
import '../dto/keyword_dto.dart';
import '../dto/pictogram_dto.dart';

extension PictogramDTOMapper on PictogramDTO {
  Pictogram toDomain() => Pictogram(
    id: id,
    description: desc,
    categories: List<String>.from(categories),
    tags: List<String>.from(tags),
    isSchematic: schematic,
    hasSexContent: sex,
    hasViolence: violence,
    createdAt: created,
    updatedAt: lastUpdated,
    downloadCount: downloads,
    keywords: keywords.map((k) => k.toDomain()).toList(),
  );
}

extension PictogramDomainMapper on Pictogram {
  PictogramDTO toDTO() => PictogramDTO(
    id: id,
    desc: description,
    categories: List<String>.from(categories),
    tags: List<String>.from(tags),
    schematic: isSchematic,
    sex: hasSexContent,
    violence: hasViolence,
    created: createdAt,
    lastUpdated: updatedAt,
    downloads: downloadCount,
    keywords: keywords.map((k) => k.toDTO()).toList(),
  );
}

extension KeywordDTOMapper on KeywordDTO {
  Keyword toDomain() => Keyword(
    id: idKeyword,
    word: keyword,
    pluralForm: plural,
    meaning: meaning,
    type: type,
    lse: lse,
  );
}

extension KeywordDomainMapper on Keyword {
  KeywordDTO toDTO() => KeywordDTO(
    idKeyword: id,
    keyword: word,
    plural: pluralForm,
    meaning: meaning,
    type: type,
    lse: lse,
  );
}
