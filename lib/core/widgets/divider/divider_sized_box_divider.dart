import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerSizedBoxDivider extends StatelessWidget {
  const DividerSizedBoxDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBoxDivider(),
        Divider(),
        SizedBoxDivider(),
      ],
    );
  }
}
