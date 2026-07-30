import 'dart:io';
import 'dart:typed_data';

import 'src/encoded_image.dart';
import 'src/image_decoder.dart';
import 'src/image_encoder.dart';

export 'src/encoded_image.dart';
export 'src/image_decoder.dart';
export 'src/image_encoder.dart';
class ImageCodec {
  const ImageCodec._();

  // ============================================================
  // FILE -> BASE64
  // ============================================================

  static Future<EncodedImage> encode(
    File file, {
    int quality = 80,
    int maxWidth = 1280,
    int maxHeight = 1280,
  }) {
    return ImageEncoder.encode(
      file,
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  // ============================================================
  // BYTES -> BASE64
  // ============================================================

  static EncodedImage encodeBytes(
    Uint8List bytes, {
    int quality = 80,
    int maxWidth = 1280,
    int maxHeight = 1280,
  }) {
    return ImageEncoder.encodeBytes(
      bytes,
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  // ============================================================
  // BASE64 -> BYTES
  // ============================================================

  static Uint8List decode(
    String base64String,
  ) {
    return ImageDecoder.decode(
      base64String,
    );
  }
}