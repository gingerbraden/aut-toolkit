import 'keyword.dart';

class Pictogram {
  final int id;
  final String description;
  final List<String> categories;
  final List<String> tags;
  final bool isSchematic;
  final bool hasSexContent;
  final bool hasViolence;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int downloadCount;
  final List<Keyword> keywords;

  Pictogram({
    required this.id,
    required this.description,
    required this.categories,
    required this.tags,
    required this.isSchematic,
    required this.hasSexContent,
    required this.hasViolence,
    required this.createdAt,
    required this.updatedAt,
    required this.downloadCount,
    required this.keywords,
  });
}


