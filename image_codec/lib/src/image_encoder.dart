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
    final originalBytes =
        await file.readAsBytes();

    final originalSize =
        originalBytes.length;

    final image =
        img.decodeImage(originalBytes);

    if (image == null) {
      throw const FormatException(
        'Unable to decode image.',
      );
    }

    img.Image processedImage = image;

    // Resize only when necessary.
    if (image.width > maxWidth ||
        image.height > maxHeight) {
      processedImage =
          img.copyResize(
        image,
        width: image.width > image.height
            ? maxWidth
            : null,
        height: image.height >= image.width
            ? maxHeight
            : null,
        maintainAspect: true,
      );
    }

    final Uint8List compressedBytes =
        Uint8List.fromList(
      img.encodeJpg(
        processedImage,
        quality: quality,
      ),
    );

    final base64String =
        base64Encode(compressedBytes);

    final base64Size =
        utf8.encode(base64String).length;

    return EncodedImage(
      data: base64String,
      mimeType: 'image/jpeg',
      extension: 'jpg',
      originalSize: originalSize,
      compressedSize:
          compressedBytes.length,
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
      processedImage =
          img.copyResize(
        image,
        width: image.width > image.height
            ? maxWidth
            : null,
        height: image.height >= image.width
            ? maxHeight
            : null,
        maintainAspect: true,
      );
    }

    final compressedBytes =
        Uint8List.fromList(
      img.encodeJpg(
        processedImage,
        quality: quality,
      ),
    );

    final base64String =
        base64Encode(compressedBytes);

    final base64Size =
        utf8.encode(base64String).length;

    return EncodedImage(
      data: base64String,
      mimeType: 'image/jpeg',
      extension: 'jpg',
      originalSize: originalSize,
      compressedSize:
          compressedBytes.length,
      base64Size: base64Size,
      width: processedImage.width,
      height: processedImage.height,
    );
  }
}