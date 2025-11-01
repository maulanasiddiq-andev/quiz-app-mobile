import 'dart:io';
import 'dart:ui';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(Color toolbarColor, Color toolbarWidgetColor) async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Atur Gambar',
          toolbarColor: toolbarColor,
          toolbarWidgetColor: toolbarWidgetColor,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    if (croppedImage != null) {
      return File(croppedImage.path);
    }
  }

  return null;
}