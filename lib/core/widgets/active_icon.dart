import 'package:flutter/material.dart';

class ActiveIcon extends StatelessWidget {
  final bool isActiveFlag;

  const ActiveIcon({super.key, required this.isActiveFlag});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isActiveFlag ? Icons.timer : Icons.timer_off,
      color: isActiveFlag ? Colors.green : Colors.redAccent,
    );
  }
}
