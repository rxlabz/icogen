import 'dart:io';

import 'package:image/image.dart';

int hexToABGR(String hexColor) {
  final hexValue = hexColor.replaceAll('#', '');
  if (hexValue.length != 6) {
    stderr.writeln('Invalid Color : $hexColor ( required format #112233 ) ');
    exit(1);
  }

  final r = int.tryParse(hexValue.substring(0, 2), radix: 16);
  final g = int.tryParse(hexValue.substring(2, 4), radix: 16);
  final b = int.tryParse(hexValue.substring(4, 6), radix: 16);

  if (_isChannelValid(r) && _isChannelValid(g) && _isChannelValid(b)) {
    return Color.fromRgba(r, g, b, 255);
  }

  stderr.writeln('Invalid color : $hexColor ');
  exit(1);
}

bool _isChannelValid(int value) => value != null && value >= 0 && value <= 255;

Future<Image> imageFromFile(File file) async {
  final bytes = await file.readAsBytes();
  return PngDecoder().decodeImage(bytes);
}
