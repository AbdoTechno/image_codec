# image_codec

A reusable Dart/Flutter image codec package for compressing images, resizing them, and converting them to Base64 for easy upload to servers or storage.

## How to add this package to any project

If your package is already on GitHub, anyone can use it directly without downloading the files locally.

### Option 1: Install from GitHub directly

Add this to your app's pubspec.yaml:

```yaml
dependencies:
  image_codec:
    git:
      url: https://github.com/your-username/image_codec.git
```

Then run:

```bash
flutter pub get
```

After that, import it in your code:

```dart
import 'package:image_codec/image_codec.dart';
```

### Option 2: Install from a specific branch or tag

```yaml
dependencies:
  image_codec:
    git:
      url: https://github.com/your-username/image_codec.git
      ref: main
```

You can replace `main` with a branch name, tag, or commit hash.

### Option 3: Install from pub.dev

If you publish it later to pub.dev, use:

```yaml
dependencies:
  image_codec: ^1.0.0
```

## Why this package?

This package is designed around a simple and reusable flow:

Image -> Resize/Compress -> Base64 -> Server -> Base64 -> Decode -> Bytes -> Cache/UI

The goal is not just to convert an image to Base64, but to reduce its size before sending it over the network.

## Main features

- Compress image files and byte arrays
- Resize images before encoding
- Return useful metadata such as width, height, size, and compression ratio
- Decode Base64 strings and data URLs back into raw bytes
- Keep a clean API that can be reused across multiple apps

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

## Installation

Add the package to your project:

```yaml
dependencies:
  image_codec:
    path: ../image_codec
```

If you publish it later to pub.dev, you can use:

```yaml
dependencies:
  image_codec: ^1.0.0
```

## Core API

The package exposes a single entry point:

```dart
import 'package:image_codec/image_codec.dart';
```

### Encode an image from a File

```dart
import 'dart:io';
import 'package:image_codec/image_codec.dart';

final file = File('path/to/image.jpg');

final result = await ImageCodec.encode(file);

print(result.data);              // Base64 string
print(result.originalSize);      // original image size in bytes
print(result.compressedSize);    // compressed image size in bytes
print(result.base64Size);        // Base64 size in bytes
print(result.base64Length);      // number of Base64 characters
print(result.compressionRatio);  // reduction ratio
print(result.compressionPercentage); // percentage reduced
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

The returned object is an `EncodedImage` with the following properties:

- `data`: the Base64 string to send to the server
- `mimeType`: the MIME type of the encoded image
- `extension`: the file extension such as `jpg`
- `originalSize`: size of the original image bytes
- `compressedSize`: size after compression
- `base64Size`: size of the Base64 string representation
- `width`: resized/compressed image width
- `height`: resized/compressed image height
- `base64Length`: number of Base64 characters
- `compressionRatio`: how much size was reduced
- `compressionPercentage`: compression ratio as a percentage
- `base64OverheadPercentage`: overhead introduced by Base64 encoding

## Human-readable size helpers

```dart
print(result.originalSizeFormatted);
print(result.compressedSizeFormatted);
print(result.base64SizeFormatted);
```

## Recommended defaults

A good starting point for most apps:

```dart
final result = await ImageCodec.encode(
  file,
  quality: 80,
  maxWidth: 1280,
  maxHeight: 1280,
);
```

### Suggested values

- `quality: 80` for a balanced size/quality tradeoff
- `maxWidth: 1280`
- `maxHeight: 1280`

## Example: upload to server

```dart
import 'dart:io';
import 'package:image_codec/image_codec.dart';

final file = File('path/to/image.jpg');
final encoded = await ImageCodec.encode(file, quality: 80);

final imageString = encoded.data;

// Send to your API
await api.uploadImage(imageString);
```

## Example: receive from server and display

```dart
import 'package:image_codec/image_codec.dart';

final bytes = ImageCodec.decode(serverImageString);

// Use it in your app
// Image.memory(bytes);
```

## Notes

- The package currently encodes images as JPEG for efficient compression.
- This package focuses on compression, encoding, decoding, and metadata only.
- It does not handle image picking, caching, upload, or UI rendering directly.

## Design goal

This package is intentionally reusable and framework-agnostic. It can be used in:

- Flutter apps
- custom clients
- backend utilities
- shared image-processing workflows

It is meant to be a clean reusable image codec layer between your app and your server.
