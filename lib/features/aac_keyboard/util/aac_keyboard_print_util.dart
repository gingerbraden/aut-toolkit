import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'aac_keyboard_print_view.dart';

class AACKeyboardPrintUtil {
  static Future<void> shareWithSharePlus(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'AAC Keyboard');
  }

  static List<AACKeyboard> collectKeyboardsDepthFirst(AACKeyboard root) {
    final out = <AACKeyboard>[];
    final visited = <String>{};

    String keyOf(AACKeyboard kb) =>
        kb.remoteId ?? kb.id?.toString() ?? kb.hashCode.toString();

    void walk(AACKeyboard kb) {
      final k = keyOf(kb);
      if (visited.contains(k)) return;
      visited.add(k);

      out.add(kb);

      for (final s in kb.slots) {
        final child = s.keyboard;
        if (child != null) walk(child);
      }
    }

    walk(root);
    return out;
  }

  static Future<Uint8List> renderWidgetToPngOffscreen({
    required Widget widget,
    required Size logicalSize,
    double pixelRatio = 3.0,
    Future<void> Function(BuildContext context)? beforeSnapshot,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    final repaintBoundary = RenderRepaintBoundary();
    final view = WidgetsBinding.instance.platformDispatcher.views.first;

    final logical = BoxConstraints.tight(logicalSize);
    final physical = logical * view.devicePixelRatio;

    final renderView = RenderView(
      view: view,
      configuration: ViewConfiguration(
        logicalConstraints: logical,
        physicalConstraints: physical,
        devicePixelRatio: view.devicePixelRatio,
      ),
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(
            size: logicalSize,
            devicePixelRatio: view.devicePixelRatio,
          ),
          child: SizedBox(
            width: logicalSize.width,
            height: logicalSize.height,
            child: widget,
          ),
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    if (beforeSnapshot != null) {
      await beforeSnapshot(rootElement);
    }

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Failed to convert rendered widget to PNG.');
    }

    return byteData.buffer.asUint8List();
  }

  static Future<File> exportToA4PdfRaster({
    required AACKeyboard root,
    required ThemeData theme,
    String filename = 'aac_keyboards_raster_a4_landscape.pdf',
    double pixelRatio = 3.0,
    bool showTitle = true,
  }) async {
    final pageFormat = PdfPageFormat.a4.landscape;

    final logicalSize = Size(pageFormat.width, pageFormat.height);

    final doc = pw.Document();
    final keyboards = collectKeyboardsDepthFirst(root);

    for (final kb in keyboards) {
      final pngBytes = await renderWidgetToPngOffscreen(
        logicalSize: logicalSize,
        pixelRatio: pixelRatio,
        widget: Theme(
          data: theme,
          child: KeyboardPrintView(keyboard: kb, showTitle: showTitle),
        ),
        beforeSnapshot: (ctx) => precacheKeyboardFileImages(kb, ctx),
      );

      final img = pw.MemoryImage(pngBytes);

      doc.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Container(
            color: PdfColors.white,
            alignment: pw.Alignment.center,
            child: pw.Image(img, fit: pw.BoxFit.contain),
          ),
        ),
      );
    }

    final bytes = await doc.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> precacheKeyboardFileImages(
    AACKeyboard keyboard,
    BuildContext context,
  ) async {
    final futures = <Future<void>>[];

    for (final slot in keyboard.slots) {
      final card = slot.card;
      if (card == null) continue;

      final path = card.localImgPath;
      if (path.isEmpty) continue;

      final file = File(path);
      if (!file.existsSync()) continue;

      futures.add(precacheImage(FileImage(file), context));
    }

    await Future.wait(futures);
  }
}
