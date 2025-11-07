class UserCard {
  int? id;
  int? arasaacId;
  String userId;
  String localImgPath;
  Map<String, String> names;


  UserCard({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.names,
  });
}
