import 'package:flutter/material.dart';

class GridSettingsMenu extends StatelessWidget {
  final int rows;
  final int columns;
  final void Function(int rows, int columns) onChanged;

  const GridSettingsMenu({
    super.key,
    required this.rows,
    required this.columns,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings),
      onSelected: (value) {
        if (value == '4x4') onChanged(4, 4);
        if (value == '5x5') onChanged(5, 5);
        if (value == '6x4') onChanged(6, 4);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: '4x4', child: Text('4 × 4')),
        PopupMenuItem(value: '5x5', child: Text('5 × 5')),
        PopupMenuItem(value: '6x4', child: Text('6 × 4')),
      ],
    );
  }
}
