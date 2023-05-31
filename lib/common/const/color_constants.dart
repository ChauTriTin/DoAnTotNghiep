import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorConstants {
  static const Color appColor = Colors.redAccent;
  static Color appColorBkg = const Color(0xFFE8E3E3);
  static Color disabledColor = Colors.grey;
  static const Color colorWhite = Colors.white;
  static Color colorBlack = Colors.black;
  static Color colorGrey = const Color(0xFFF2F2F2);
  static Color loginBtnBgColor = Colors.black;

  static Color bgBackCircleColor = Colors.black;
  static Color bgBackCircle50Color = const Color(0x8C000000);
  static Color loginBtnTextColor = Colors.white;

  static Color textEditBgColor = const Color(0x98000000);
  static Color borderTextInputColor = const Color(0xA6C2C2C2);
  static Color focusBorderTextInputColor = Colors.white;
  static Color errorBorderTextInputColor = const Color(0xA6FC7F49);
  static const Color textColorForgotPassword = const Color(0xA6FFE3A6);
  static const Color iconColor = Colors.white;

  static getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}
