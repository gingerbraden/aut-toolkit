import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

class FirstThenBoard {

  int? id;
  String userId;
  UserCard first;
  UserCard then;

  FirstThenBoard({
    this.id = 0,
    required this.userId,
    required this.first,
    required this.then
  });



}