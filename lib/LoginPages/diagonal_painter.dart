import 'package:flutter/material.dart';

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the blue section
    final paint = Paint()
      ..color = const Color(0xFF001E64) // Updated to #001E64
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.75) // Just above where green starts
      ..lineTo(size.width, size.height * 0.4) // Just above green's top point
      ..lineTo(size.width, size.height * 0.5) // Meets green's top point
      ..lineTo(0, size.height * 0.85) // Meets green's left point
      ..close();

    canvas.drawPath(path, paint);

    // Draw the green section
    final greenPaint = Paint()
      ..color = const Color(0xFF25CFA2) // Updated to #25CFA2
      ..style = PaintingStyle.fill;

    final greenPath = Path()
      ..moveTo(0, size.height * 0.85)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
