import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class QrPainterCustom extends CustomPainter {
  final String data;

  QrPainterCustom({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final qrCode = QrCode(30, QrErrorCorrectLevel.H)
      ..addData(data);

    final qrImage = QrImage(qrCode);

    final int moduleCount = qrImage.moduleCount;
    final double pixelSize = size.width / moduleCount;
    final paint = Paint()..color = Colors.black;

    for (int y = 0; y < moduleCount; y++) {
      for (int x = 0; x < moduleCount; x++) {
        if (qrImage.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize,
              y * pixelSize,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}