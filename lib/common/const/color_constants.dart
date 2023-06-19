import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorConstants {
  static const Color appColor = Colors.redAccent;
  static Color appColorBkg = const Color(0xFFE8E3E3);
  static Color disabledColor = Colors.grey;
  static const Color colorWhite = Colors.white;
  static Color colorBlack = Colors.black;
  static const Color colorGrey = const Color(0xFFF2F2F2);
  static Color loginBtnBgColor = Colors.black;

  static Color bgBackCircleColor = Colors.black;
  static Color bgBackCircle50Color = const Color(0x8C000000);
  static Color loginBtnTextColor = Colors.white;
  static const Color textColor = const Color(0xFF000000);
  static  Color textColorDisable = Color(0xA65D5D5D);

  static Color textEditBgColor = const Color(0x98000000);
  static Color borderTextInputColor = const Color(0xA6C2C2C2);
  static Color focusBorderTextInputColor = Colors.white;
  static Color errorBorderTextInputColor = const Color(0xFFFDC10B);
  static const Color textColorForgotPassword = Color(0xFFFFE49A);
  static const Color iconColor = Color(0xFF313131);
  static const Color dividerColor =  Color(0xFFFDC2C2);

  static const Color colorProfile =  Color(0xFF04CB5B);
  static const Color colorMode =  Color(0xFF3B3B3B);
  static const Color colorLanguage =  Color(0xFFFFC037);
  static const Color colorAbout =  Color(0xFFDFDFDF);
  static const Color colorTermCondition =  Color(0xFF015DD6);
  static const Color colorPolicy =  Color(0xFFCD0D0F);
  static const Color colorRateApp =  Color(0xFF8C51FF);
  static const Color colorBgEditTextField =  Color(0xFFE3E3E3);
  static const Color colorGenderSelected =  Color(0xFF3B4257);

  static getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}
