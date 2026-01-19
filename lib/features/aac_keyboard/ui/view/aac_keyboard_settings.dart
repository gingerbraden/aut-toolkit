import 'package:flutter/material.dart';

import '../../../../i18n/strings.g.dart';

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
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        final result = await showDialog<_GridSizeResult>(
          context: context,
          builder: (context) =>
              _GridSizeDialog(initialRows: rows, initialColumns: columns),
        );

        if (result != null) {
          onChanged(result.rows, result.columns);
        }
      },
    );
  }
}

class _GridSizeResult {
  final int rows;
  final int columns;

  const _GridSizeResult(this.rows, this.columns);
}

class _GridSizeDialog extends StatefulWidget {
  final int initialRows;
  final int initialColumns;

  const _GridSizeDialog({
    required this.initialRows,
    required this.initialColumns,
  });

  @override
  State<_GridSizeDialog> createState() => _GridSizeDialogState();
}

class _GridSizeDialogState extends State<_GridSizeDialog> {
  late int _rows = widget.initialRows;
  late int _cols = widget.initialColumns;

  static const int _minRows = 1;
  static const int _maxRows = 12;
  static const int _minCols = 1;
  static const int _maxCols = 12;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.grid_settings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperRow(
            label: t.rows,
            value: _rows,
            min: _minRows,
            max: _maxRows,
            onDecrement: _rows > _minRows
                ? () => setState(() => _rows--)
                : null,
            onIncrement: _rows < _maxRows
                ? () => setState(() => _rows++)
                : null,
          ),
          _StepperRow(
            label: t.cols,
            value: _cols,
            min: _minCols,
            max: _maxCols,
            onDecrement: _cols > _minCols
                ? () => setState(() => _cols--)
                : null,
            onIncrement: _cols < _maxCols
                ? () => setState(() => _cols++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(_GridSizeResult(_rows, _cols)),
          child: Text(t.save),
        ),
      ],
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.arrow_left),
        ),
        SizedBox(
          width: 48,
          child: Center(
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
