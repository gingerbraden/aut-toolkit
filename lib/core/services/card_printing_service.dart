import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../features/card_management/domain/model/user_card.dart';
import '../../i18n/strings.g.dart';

class CardPrintingService {
  static final CardPrintingService _instance = CardPrintingService._();

  factory CardPrintingService() => _instance;

  CardPrintingService._();

  Future<void> generateAndShareSelectedCardsPdf(
    List<UserCard> cards, {
    int cardsPerRow = 4,
  }) async {
    if (cards.isEmpty) return;

    final pdf = pw.Document();

    final regularFont = pw.Font.ttf(
      await rootBundle.load('res/fonts/NotoSans-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('res/fonts/NotoSans-Bold.ttf'),
    );

    final images = <Uint8List?>[];
    for (final card in cards) {
      images.add(await _loadImage(card.localImgPath));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        build: (context) {
          return [
            pw.GridView(
              crossAxisCount: cardsPerRow,
              childAspectRatio: 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              children: List.generate(cards.length, (index) {
                final card = cards[index];
                final imageData = images[index];

                final localizedName =
                    card.names[LocaleSettings.currentLocale.languageCode] ??
                    card.names.values.firstOrNull ??
                    '';

                return pw.Container(
                  padding: const pw.EdgeInsets.all(6),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey, width: 1),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      if (imageData != null)
                        pw.Expanded(
                          child: pw.Image(
                            pw.MemoryImage(imageData),
                            fit: pw.BoxFit.contain,
                          ),
                        ),

                      pw.SizedBox(height: 6),

                      pw.Text(
                        localizedName,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ];
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/printable_cards.pdf');

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<Uint8List?> _loadImage(String? path) async {
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    if (!await file.exists()) return null;
    return await file.readAsBytes();
  }
}
