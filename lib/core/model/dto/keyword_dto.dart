class KeywordDTO {
  final int idKeyword;
  final String keyword;
  final String? plural;
  final String? meaning;
  final int? type;
  final int? lse;

  KeywordDTO({
    required this.idKeyword,
    required this.keyword,
    this.plural,
    this.meaning,
    this.type,
    this.lse,
  });

  factory KeywordDTO.fromJson(Map<String, dynamic> json) {
    return KeywordDTO(
      idKeyword: json['idKeyword'] ?? 0,
      keyword: json['keyword'] ?? '',
      plural: json['plural'],
      meaning: json['meaning'],
      type: json['type'],
      lse: json['lse'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idKeyword': idKeyword,
    'keyword': keyword,
    'plural': plural,
    'meaning': meaning,
    'type': type,
    'lse': lse,
  };
}
