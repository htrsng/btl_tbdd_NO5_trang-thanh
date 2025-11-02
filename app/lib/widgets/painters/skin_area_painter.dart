import 'package:flutter/material.dart';
import 'dart:math' as math;

class SkinAreaPainter extends CustomPainter {
  final Color color;
  final Path path;
  final int dotCount;

  SkinAreaPainter({
    required this.color,
    required this.path,
    this.dotCount = 200,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    final random = math.Random(123);
    final Rect bounds = path.getBounds();

    for (int i = 0; i < dotCount; i++) {
      final double x = bounds.left + random.nextDouble() * bounds.width;
      final double y = bounds.top + random.nextDouble() * bounds.height;
      final Offset offset = Offset(x, y);
      if (path.contains(offset)) canvas.drawCircle(offset, 0.45, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
