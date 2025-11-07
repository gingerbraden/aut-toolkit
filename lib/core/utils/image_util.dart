import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../i18n/strings.g.dart';

class ImageUtil {
  static Future<String?> pickAndStoreImage(Color surfaceColor, Color textColor) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(toolbarTitle: t.crop_image, lockAspectRatio: true, toolbarWidgetColor: textColor, toolbarColor: surfaceColor, backgroundColor: surfaceColor, hideBottomControls: true),
        IOSUiSettings(title: t.crop_image, aspectRatioLockEnabled: true),
      ],
    );

    if (croppedFile == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = path.join(appDir.path, fileName);

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      savedPath,
      quality: 80,
    );

    if (compressedFile == null) return null;

    return compressedFile.path;
  }

  static Future<String?> saveImageFromUrl(String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    try {
      final dio = Dio();

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = imageUrl.split("/").last;
      final filePath = path.join(appDir.path, fileName);

      await dio.download(
        imageUrl,
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      if (!await file.exists()) return null;

      return file.path;
    } catch (e) {
      print('Error saving image from URL: $e');
      return null;
    }
  }


  static void deleteImage(String path) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
}
