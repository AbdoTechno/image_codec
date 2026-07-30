import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'encoded_image.dart';

class ImageEncoder {
  static Future<EncodedImage> encode(
    File file, {
    int quality = 80,
    int maxWidth = 1280,
    int maxHeight = 1280,
  }) async {
    _validateResizeOptions(
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    final originalBytes = await file.readAsBytes();

    final originalSize = originalBytes.length;

    final image = img.decodeImage(originalBytes);

    if (image == null) {
      throw const FormatException(
        'Unable to decode image.',
      );
    }

    img.Image processedImage = image;

    // Resize only when necessary.
    if (image.width > maxWidth ||
        image.height > maxHeight) {
      processedImage = img.copyResize(
        image,
        width: image.width > image.height ? maxWidth : null,
        height:
            image.height >= image.width ? maxHeight : null,
        maintainAspect: true,
      );
    }

    final Uint8List compressedBytes = Uint8List.fromList(
      img.encodeJpg(
        processedImage,
        quality: quality,
      ),
    );

    final base64String = base64Encode(compressedBytes);

    final base64Size = utf8.encode(base64String).length;

    return EncodedImage(
      data: base64String,
      mimeType: 'image/jpeg',
      extension: 'jpg',
      originalSize: originalSize,
      compressedSize: compressedBytes.length,
      base64Size: base64Size,
      width: processedImage.width,
      height: processedImage.height,
    );
  }

  static EncodedImage encodeBytes(
    Uint8List bytes, {
    int quality = 80,
    int maxWidth = 1280,
    int maxHeight = 1280,
  }) {
    _validateResizeOptions(
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    if (bytes.isEmpty) {
      throw const FormatException(
        'Cannot encode empty bytes.',
      );
    }

    final originalSize = bytes.length;

    final image = img.decodeImage(bytes);

    if (image == null) {
      throw const FormatException(
        'Unable to decode image.',
      );
    }

    img.Image processedImage = image;

    if (image.width > maxWidth ||
        image.height > maxHeight) {
      processedImage = img.copyResize(
        image,
        width: image.width > image.height ? maxWidth : null,
        height:
            image.height >= image.width ? maxHeight : null,
        maintainAspect: true,
      );
    }

    final compressedBytes = Uint8List.fromList(
      img.encodeJpg(
        processedImage,
        quality: quality,
      ),
    );

    final base64String = base64Encode(compressedBytes);

    final base64Size = utf8.encode(base64String).length;

    return EncodedImage(
      data: base64String,
      mimeType: 'image/jpeg',
      extension: 'jpg',
      originalSize: originalSize,
      compressedSize: compressedBytes.length,
      base64Size: base64Size,
      width: processedImage.width,
      height: processedImage.height,
    );
  }

  static void _validateResizeOptions({
    required int quality,
    required int maxWidth,
    required int maxHeight,
  }) {
    if (quality <= 0 || quality > 100) {
      throw ArgumentError.value(
        quality,
        'quality',
        'Must be between 1 and 100.',
      );
    }

    if (maxWidth <= 0) {
      throw ArgumentError.value(
        maxWidth,
        'maxWidth',
        'Must be greater than 0.',
      );
    }

    if (maxHeight <= 0) {
      throw ArgumentError.value(
        maxHeight,
        'maxHeight',
        'Must be greater than 0.',
      );
    }
  }
}
