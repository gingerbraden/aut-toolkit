class Keyword {
  final int id;
  final String word;
  final String? pluralForm;
  final String? meaning;
  final int? type;
  final int? lse;

  Keyword({
    required this.id,
    required this.word,
    this.pluralForm,
    this.meaning,
    this.type,
    this.lse,
  });
}