import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class QwertyKeyboard extends StatefulWidget {
  final String typedText;
  final VoidCallback onClose;
  final void Function(String key) onKey;
  final void Function() onSpeak;

  const QwertyKeyboard({
    super.key,
    required this.typedText,
    required this.onClose,
    required this.onKey,
    required this.onSpeak,
  });

  static const _rows = <List<String>>[
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];

  @override
  State<QwertyKeyboard> createState() => _QwertyKeyboardState();
}

class _QwertyKeyboardState extends State<QwertyKeyboard> {
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(covariant QwertyKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.typedText.length > oldWidget.typedText.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  IconButton _roundActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color background,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 32,
      style: IconButton.styleFrom(
        backgroundColor: background,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: const CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.BASE_APP_UI_PADDING,
          ),
          child: SizedBox(
            height: 130,
            child: Row(
              children: [
                _roundActionButton(
                  onPressed: widget.onClose,
                  icon: Icons.insert_emoticon_sharp,
                  background: Theme.of(context).colorScheme.primary,
                ),

                SizedBox(width: AppConstants.BASE_APP_UI_PADDING),

                Expanded(
                  child: InkWell(
                    onTap: widget.onSpeak,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: SingleChildScrollView(
                          controller: _scroll,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.typedText.isEmpty ? ' ' : widget.typedText,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    children: [
                      _roundActionButton(
                        onPressed: () => widget.onKey('{backspace}'),
                        icon: Icons.backspace,
                        background: Colors.red.shade600,
                      ),
                      SizedBox(width: AppConstants.BASE_APP_UI_PADDING),
                      _roundActionButton(
                        onPressed: () => widget.onKey('{clear}'),
                        icon: Icons.clear,
                        background: Colors.red.shade600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              const topRowCount = 10;

              final keySize =
                  (constraints.maxWidth * 0.8 - spacing * (topRowCount - 1)) /
                  topRowCount;

              Widget row(List<String> keys) {
                return Wrap(
                  spacing: spacing,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final k in keys)
                      _KeyButton.square(
                        label: k,
                        size: keySize,
                        onTap: () => widget.onKey(k),
                      ),
                  ],
                );
              }

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    row(QwertyKeyboard._rows[0]),
                    const SizedBox(height: 10),
                    row(QwertyKeyboard._rows[1]),
                    const SizedBox(height: 10),
                    row(QwertyKeyboard._rows[2]),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: spacing,
                      alignment: WrapAlignment.center,
                      children: [
                        _KeyButton(
                          label: 'Space',
                          width: keySize * 5 + spacing * 4,
                          height: keySize,
                          onTap: () => widget.onKey(' '),
                        ),
                        _KeyButton.square(
                          label: '.',
                          size: keySize,
                          onTap: () => widget.onKey('.'),
                        ),
                        _KeyButton.square(
                          label: ',',
                          size: keySize,
                          onTap: () => widget.onKey(','),
                        ),
                        _KeyButton.square(
                          label: '´',
                          size: keySize,
                          onTap: () => widget.onKey('{acute}'),
                        ),
                        _KeyButton.square(
                          label: 'ˇ',
                          size: keySize,
                          onTap: () => widget.onKey('{caron}'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _KeyButton({
    required this.label,
    required this.onTap,
    required this.width,
    required this.height,
  });

  factory _KeyButton.square({
    required String label,
    required double size,
    required VoidCallback onTap,
  }) {
    return _KeyButton(label: label, width: size, height: size, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
