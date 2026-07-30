class EncodedImage {
  final String data;

  final String mimeType;

  final String extension;

  final int originalSize;

  final int compressedSize;

  final int base64Size;

  final int width;

  final int height;

  const EncodedImage({
    required this.data,
    required this.mimeType,
    required this.extension,
    required this.originalSize,
    required this.compressedSize,
    required this.base64Size,
    required this.width,
    required this.height,
  });

  /// Number of Base64 characters.
  int get base64Length => data.length;

  /// How much the compressed image was reduced.
  double get compressionRatio {
    if (originalSize == 0) {
      return 0;
    }

    return 1 - (compressedSize / originalSize);
  }

  /// Compression percentage.
  double get compressionPercentage {
    return compressionRatio * 100;
  }

  /// Base64 size increase compared with compressed image.
  double get base64OverheadPercentage {
    if (compressedSize == 0) {
      return 0;
    }

    return ((base64Size - compressedSize) /
            compressedSize) *
        100;
  }

  /// Human readable original size.
  String get originalSizeFormatted {
    return _formatBytes(originalSize);
  }

  /// Human readable compressed size.
  String get compressedSizeFormatted {
    return _formatBytes(compressedSize);
  }

  /// Human readable Base64 size.
  String get base64SizeFormatted {
    return _formatBytes(base64Size);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'mimeType': mimeType,
      'extension': extension,
      'width': width,
      'height': height,
    };
  }

  factory EncodedImage.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as String;

    return EncodedImage(
      data: data,
      mimeType:
          json['mimeType'] as String? ??
              'image/jpeg',
      extension:
          json['extension'] as String? ??
              'jpg',
      originalSize:
          json['originalSize'] as int? ??
              0,
      compressedSize:
          json['compressedSize'] as int? ??
              0,
      base64Size:
          json['base64Size'] as int? ??
              0,
      width:
          json['width'] as int? ??
              0,
      height:
          json['height'] as int? ??
              0,
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}