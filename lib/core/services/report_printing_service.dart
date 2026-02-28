import 'dart:io';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../i18n/strings.g.dart';

class ReportPrintingService {
  static final ReportPrintingService _instance = ReportPrintingService._();

  factory ReportPrintingService() => _instance;

  ReportPrintingService._();

  Future<void> generateAndSharePdf() async {
    final pdf = pw.Document();

    final regularFont = pw.Font.ttf(
      await rootBundle.load('res/fonts/NotoSans-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('res/fonts/NotoSans-Bold.ttf'),
    );

    final defaultTextStyle = pw.TextStyle(
      font: regularFont,
      fontBold: boldFont,
    );

    final cbs = RepoService().challengingBehaviourRepository.getAllCb();
    final ghs = RepoService().goodHabitRepository.getAllHabits();
    final ehs = RepoService().eatingHabitRepository.getAllHabits();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              t.challenging_behaviour,
              style: pw.TextStyle(fontSize: 24),
            ),
          ),
          if (cbs.isNotEmpty)
            ...cbs.expand(
              (behaviour) => [
                pw.SizedBox(height: 5),
                pw.Text(
                  behaviour.name,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                pw.Text('${t.notes}: ${behaviour.description}'),
                pw.Text('${t.occuring}: ${behaviour.occuring ? t.yes : t.no}'),
                pw.SizedBox(height: 5),
                pw.Text(
                  '${t.entry}:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                if (behaviour.diaryEntries.isNotEmpty)
                  ...behaviour.diaryEntries.map(
                    (entry) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Divider(),
                        pw.Text('${t.date}: ${entry.date}'),
                        pw.Text('${t.location}: ${entry.location}'),
                        pw.Text(
                          '${t.duration}: ${entry.duration} ${t.minute(n: entry.duration)}',
                        ),
                        pw.Text('${t.circumstances}: ${entry.circumstances}'),
                        pw.Text(
                          '${t.people_present}: ${entry.people.join(", ")}',
                        ),
                        pw.Text('${t.outcome}: ${entry.outcome}'),
                        pw.Text('${t.reflection}: ${entry.reflection}'),
                      ],
                    ),
                  ),
                pw.Divider(thickness: 2),
              ],
            ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(t.good_habits, style: pw.TextStyle(fontSize: 24)),
          ),
          if (ghs.isNotEmpty)
            ...ghs.map(
              (gh) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 5),
                  pw.Text(
                    gh.name,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  pw.Text('${t.notes}: ${gh.description}'),
                  pw.Text('${t.occuring}: ${gh.isOcuringFlag ? t.yes : t.no}'),
                  pw.Text('${t.from}: ${gh.from}'),
                  if (gh.to != null) pw.Text('${t.to}: ${gh.to}'),
                  pw.Divider(),
                ],
              ),
            ),
        ],
      ),
    );

    final List<Uint8List?> images = [];
    for (var eh in ehs) {
      images.add(await _loadImage(eh.imageFilePath));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(t.eating_habits, style: pw.TextStyle(fontSize: 24)),
          ),
          if (ehs.isNotEmpty)
            ...List.generate(ehs.length, (index) {
              final eh = ehs[index];
              final imageData = images[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 5),
                  pw.Text(
                    eh.name,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  pw.Text('${t.notes}: ${eh.description}'),
                  pw.Text('${t.is_eating}: ${eh.isEatingFlag ? t.yes : t.no}'),
                  pw.Text('${t.from}: ${eh.from}'),
                  if (eh.to != null) pw.Text('${t.to}: ${eh.to}'),

                  if (imageData != null) pw.SizedBox(height: 10),
                  if (imageData != null)
                    pw.Image(
                      pw.MemoryImage(imageData),
                      width: 200,
                      height: 200,
                      fit: pw.BoxFit.cover,
                    ),

                  pw.Divider(),
                ],
              );
            }),
        ],
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/combined_habits_report.pdf');
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
