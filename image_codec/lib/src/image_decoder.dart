import 'dart:convert';
import 'dart:typed_data';

class ImageDecoder {
  static Uint8List decode(
    String value,
  ) {
    final normalized =
        _normalizeBase64(value);

    if (normalized.isEmpty) {
      throw const FormatException(
        'Base64 string is empty.',
      );
    }

    try {
      return base64Decode(normalized);
    } catch (_) {
      throw const FormatException(
        'Invalid Base64 image string.',
      );
    }
  }

  static String _normalizeBase64(
    String input,
  ) {
    var value = input.trim();

    if (value.startsWith('data:')) {
      final commaIndex =
          value.indexOf(',');

      if (commaIndex != -1) {
        value =
            value.substring(
          commaIndex + 1,
        );
      }
    }

    value =
        value.replaceAll(
      RegExp(r'\s+'),
      '',
    );

    return value;
  }
}