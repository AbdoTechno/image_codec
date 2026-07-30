# image_codec

A reusable Dart/Flutter image codec package for compressing images, resizing them, and converting them to Base64 for easy upload to servers or storage.

## ✅ Quick start

If your package lives inside a subfolder named `image_codec` in your GitHub repository, add this to your app's `pubspec.yaml`:

```yaml
dependencies:
  image_codec:
    git:
      url: https://github.com/AbdoTechno/image_codec.git
      path: image_codec
```

Then run:

```bash
flutter pub get
```

Import it in your Dart code:

```dart
import 'package:image_codec/image_codec.dart';
```

### Install from a specific branch or tag

```yaml
dependencies:
  image_codec:
    git:
      url: https://github.com/AbdoTechno/image_codec.git
      path: image_codec
      ref: main
```

### Install from pub.dev

If you publish the package later, use:

```yaml
dependencies:
  image_codec: ^1.0.0
```

## Why this package?

This package is built for the common use case where you want to send images to a server, but you also want to reduce their size first.

The flow is:

`Image → Resize/Compress → Base64 → Server → Base64 → Decode → Bytes → Cache/UI`

It is not just a Base64 converter: it is a reusable image codec layer that helps keep uploads smaller and faster.

## Main features

- Compress image files and byte arrays
- Resize images before encoding
- Return metadata like width, height, and compression stats
- Decode Base64 strings or data URLs back into raw bytes
- Keep API simple and reusable across apps

## Package structure

```text
image_codec/
├── pubspec.yaml
└── lib/
    ├── image_codec.dart
    └── src/
        ├── encoded_image.dart
        ├── image_encoder.dart
        └── image_decoder.dart
```

## Core API

Use the package with a single import:

```dart
import 'package:image_codec/image_codec.dart';
```

### Encode an image from a File

```dart
import 'dart:io';
import 'package:image_codec/image_codec.dart';

final file = File('path/to/image.jpg');
final result = await ImageCodec.encode(file);

print(result.data);
print(result.originalSize);
print(result.compressedSize);
print(result.base64Size);
print(result.base64Length);
print(result.compressionRatio);
print(result.compressionPercentage);
```

### Encode from bytes

```dart
import 'dart:typed_data';
import 'package:image_codec/image_codec.dart';

final bytes = Uint8List.fromList([1, 2, 3, 4]);
final result = ImageCodec.encodeBytes(bytes);
```

### Decode Base64 back to bytes

```dart
import 'package:image_codec/image_codec.dart';

final bytes = ImageCodec.decode(result.data);
```

## What the result contains

`ImageCodec.encode()` and `ImageCodec.encodeBytes()` return an `EncodedImage` with:

- `data`: Base64 string ready for upload
- `mimeType`: image MIME type (e.g. `image/jpeg`)
- `extension`: file extension (e.g. `jpg`)
- `originalSize`: size of the original image bytes
- `compressedSize`: size after compression
- `base64Size`: size of the Base64 string
- `width`: output image width
- `height`: output image height
- `base64Length`: length of the Base64 string
- `compressionRatio`: compression ratio
- `compressionPercentage`: compression percentage
- `base64OverheadPercentage`: Base64 overhead compared to compressed bytes

## Human-readable sizes

```dart
print(result.originalSizeFormatted);
print(result.compressedSizeFormatted);
print(result.base64SizeFormatted);
```

## Recommended defaults

Use these values for a good size/quality balance:

```dart
final result = await ImageCodec.encode(
  file,
  quality: 80,
  maxWidth: 1280,
  maxHeight: 1280,
);
```

### Suggested values

- `quality: 80` — balanced quality and size
- `maxWidth: 1280`
- `maxHeight: 1280`

## Example: upload to server

```dart
import 'dart:io';
import 'package:image_codec/image_codec.dart';

final file = File('path/to/image.jpg');
final encoded = await ImageCodec.encode(file, quality: 80);
final imageString = encoded.data;

await api.uploadImage(imageString);
```

## Example: receive from server and display

```dart
import 'package:image_codec/image_codec.dart';

final bytes = ImageCodec.decode(serverImageString);

// Display the image
// Image.memory(bytes);
```

## Notes

- The package currently encodes images as JPEG for efficient compression.
- It focuses on compression, encoding, decoding, and metadata only.
- It does not handle image picking, caching, upload, or UI rendering directly.

## Design goal

This package is intentionally reusable and framework-agnostic.
It can be used in:

- Flutter apps
- custom clients
- backend utilities
- shared image-processing workflows

It is meant to be a clean reusable image codec layer between your app and your server.

- Flutter apps
- custom clients
- backend utilities
- shared image-processing workflows

It is meant to be a clean reusable image codec layer between your app and your server.
