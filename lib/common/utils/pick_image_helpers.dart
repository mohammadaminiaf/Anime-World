import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PickImageHelpers {
  /// Pick a single image from camera/gallery
  static Future<File?> pickImage({
    ImageSource? source,
  }) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source ?? ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 1200,
      maxWidth: 1200,
    );
    if (file != null) {
      return File(file.path);
    }
    return null;
  }

  // Crop a single image
  static Future<File> cropImage({required String imagePath}) async {
    final cropper = ImageCropper();
    final croppedImage = await cropper.cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    if (croppedImage != null) {
      return File(croppedImage.path);
    }
    return File(imagePath);
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImage({int? limit}) async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(
      imageQuality: 75,
      maxHeight: 1200,
      maxWidth: 1200,
      limit: limit,
    );
    if (files.isNotEmpty) {
      return files.map((file) => File(file.path)).toList();
    }
    return <File>[];
  }

  /// Pick and crop an image from gallery
  static Future<File?> pickAndCropImage({
    ImageSource? source,
    bool? freeTransform,
  }) async {
    final cropper = ImageCropper();
    final image = await pickImage(source: source);
    if (image != null) {
      final croppedImage = await cropper.cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: false,
          ),
        ],
      );
      if (croppedImage != null) {
        return File(croppedImage.path);
      }
    }
    return null;
  }

  /// Pick and crop multiple images from gallery
  static Future<List<File>> pickAndCropMultiImage({int limit = 0}) async {
    try {
      List<File> croppedImages = [];
      final images = await pickMultipleImage();

      if (images.isEmpty) return croppedImages;

      for (var i = 0; i < images.length; i++) {
        if (limit > 0 && croppedImages.length >= limit) break;

        final croppedImage = await cropImage(imagePath: images[i].path);
        croppedImages.add(croppedImage);
      }

      return croppedImages;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  const PickImageHelpers._();
}
