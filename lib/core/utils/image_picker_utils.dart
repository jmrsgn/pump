import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  ImagePickerUtils._();

  static final ImagePicker _picker = ImagePicker();

  /// Opens the device gallery and allows the user to select an image.
  ///
  /// Returns:
  /// - [File] if an image was selected
  /// - `null` if the user cancels the picker
  static Future<File?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  /// Opens the device camera and allows the user to capture an image.
  ///
  /// Returns:
  /// - [File] if an image was captured
  /// - `null` if the user cancels the camera
  static Future<File?> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }
}
