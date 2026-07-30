import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:image_codec/image_codec.dart';

void main() {
  group('ImageCodec', () {
    test('throws ArgumentError for invalid quality', () {
      final imageBytes = _createTestImageBytes();

      expect(
        () =>
            ImageCodec.encodeBytes(imageBytes, quality: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('encodes and decodes a valid image', () {
      final imageBytes = _createTestImageBytes();

      final encoded = ImageCodec.encodeBytes(imageBytes);
      final decoded = ImageCodec.decode(encoded.data);

      expect(encoded.data, isNotEmpty);
      expect(encoded.width, 2);
      expect(encoded.height, 2);
      expect(decoded, isNotEmpty);
    });

    test('decodes base64 data URLs', () {
      final payload = base64Encode([1, 2, 3, 4]);
      final decoded = ImageCodec.decode(
          'data:image/jpeg;base64,$payload');

      expect(decoded, [1, 2, 3, 4]);
    });
  });
}

Uint8List _createTestImageBytes() {
  final image = img.Image(width: 2, height: 2);
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      image.setPixel(x, y, img.ColorRgba8(255, 0, 0, 255));
    }
  }
  return Uint8List.fromList(img.encodePng(image));
}
