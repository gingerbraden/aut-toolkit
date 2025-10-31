import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OccuringIcon extends StatelessWidget {
  final bool isOccuringFlag;

  const OccuringIcon({super.key, required this.isOccuringFlag});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isOccuringFlag ? Icons.play_circle_outline : Icons.pause_circle_outline,
      color: isOccuringFlag ? Colors.green : Colors.redAccent,
    );
  }
}
