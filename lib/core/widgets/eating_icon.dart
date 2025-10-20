import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EatingIcon extends StatelessWidget {
  final bool isEatingFlag;

  const EatingIcon({super.key, required this.isEatingFlag});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isEatingFlag ? Icons.restaurant : Icons.no_meals,
      color: isEatingFlag ? Colors.green : Colors.redAccent,
    );
  }
}
