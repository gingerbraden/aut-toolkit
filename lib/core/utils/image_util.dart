import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageUtil {
  static Future<String?> pickAndStoreImage() async {
    final picker = ImagePicker();

    // Step 1: Pick image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    // Step 2: Crop to square
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop Image', lockAspectRatio: true),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );

    if (croppedFile == null) return null;

    // Step 3: Compress image
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

  static void deleteImage(String path) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
}
