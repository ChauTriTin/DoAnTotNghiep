import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart';

String imageToBase64(File file, {int? height}) {
  final image = decodeImage(file.readAsBytesSync())!;
  final resizedImage = copyResize(image, height: height ?? 200);
  return base64Encode(encodeJpg(resizedImage));
}
