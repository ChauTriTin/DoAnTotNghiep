import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorConstants {
  static const Color appColor = Colors.redAccent;
  static Color appColorBkg = const Color(0xFFE8E3E3);
  static Color disabledColor = Colors.grey;
  static Color colorWhite = Colors.white;
  static Color colorBlack = Colors.black;
  static Color colorGrey = const Color(0xFFF2F2F2);
  static Color loginBtnBgColor = Colors.black;
  static Color loginBtnTextColor = Colors.white;

  static getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}
