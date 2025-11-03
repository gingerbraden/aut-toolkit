import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import 'divider/sized_box_divider.dart';

class DescriptionDetail extends StatelessWidget {
  const DescriptionDetail({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.notes,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBoxDivider(),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
