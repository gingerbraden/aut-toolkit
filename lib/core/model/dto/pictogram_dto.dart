import 'keyword_dto.dart';

/// The pictogram object returned from the ARASAAC API
class PictogramDTO {
  final int id;
  final String desc;
  final List<String> categories;
  final List<String> tags;
  final bool schematic;
  final bool sex;
  final bool violence;
  final DateTime created;
  final DateTime lastUpdated;
  final int downloads;
  final List<KeywordDTO> keywords;

  PictogramDTO({
    required this.id,
    required this.desc,
    required this.categories,
    required this.tags,
    required this.schematic,
    required this.sex,
    required this.violence,
    required this.created,
    required this.lastUpdated,
    required this.downloads,
    required this.keywords,
  });

  factory PictogramDTO.fromJson(Map<String, dynamic> json) {
    return PictogramDTO(
      id: json['_id'] ?? 0,
      desc: json['desc'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      schematic: json['schematic'] ?? false,
      sex: json['sex'] ?? false,
      violence: json['violence'] ?? false,
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      lastUpdated:
      DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
      downloads: json['downloads'] ?? 0,
      keywords: (json['keywords'] as List<dynamic>? ?? [])
          .map((k) => KeywordDTO.fromJson(k))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'desc': desc,
    'categories': categories,
    'tags': tags,
    'schematic': schematic,
    'sex': sex,
    'violence': violence,
    'created': created.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'downloads': downloads,
    'keywords': keywords.map((k) => k.toJson()).toList(),
  };
}

