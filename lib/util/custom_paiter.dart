import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Paint lightBluePaint = Paint()..color = Color(0xFFbde5fa);
  final Paint bluePaint = Paint()..color = Color(0xFF5abef2);
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  final TextStyle textStyle = TextStyle(
      color: Colors.white.withAlpha(240),
      fontSize: 18,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w900);

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromLTRB(
        -100, size.height - 120, size.width * 0.7, size.height + 250);

    final Path circle = Path()..addOval(rect);
    final Path smallCircle = Path()..addOval(rect.inflate(50));

    canvas.drawPath(smallCircle, lightBluePaint);
    canvas.drawPath(circle, bluePaint);

    drawText(canvas, size, 'Write now');
  }

  void drawText(Canvas canvas, Size size, String text) {
    textPainter.text = TextSpan(style: textStyle, text: text);
    textPainter.layout();
    textPainter.paint(canvas, Offset(50, size.height - 60));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}