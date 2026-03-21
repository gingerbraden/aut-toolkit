import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../i18n/strings.g.dart';
import '../../domain/model/challenging_behaviour_diary_entry.dart';

class ChallengingBehaviourDiaryQrScanner extends StatefulWidget {
  const ChallengingBehaviourDiaryQrScanner({super.key});

  @override
  State<ChallengingBehaviourDiaryQrScanner> createState() =>
      _ChallengingBehaviourDiaryQrScannerState();
}

class _ChallengingBehaviourDiaryQrScannerState
    extends State<ChallengingBehaviourDiaryQrScanner> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.scan_qr)),
      body: MobileScanner(
        onDetect: (capture) {
          if (_scanned) return;

          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final raw = barcodes.first.rawValue;
            if (raw != null && raw.isNotEmpty) {
              _scanned = true;
              try {
                final entry = ChallengingBehaviourDiaryEntry.fromJson(raw);
                Navigator.pop(context, entry);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.incorrect_qr),
                    behavior: SnackBarBehavior.floating,
                    showCloseIcon: true,
                  ),
                );
                _scanned = false;
              }
            }
          }
        },
      ),
    );
  }
}
