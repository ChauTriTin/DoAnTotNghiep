import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorConstants {
  static const Color appColor = Colors.redAccent;
  static Color appColorBkg = const Color(0xFFE8E3E3);
  static Color disabledColor = Colors.grey;

  static getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}
