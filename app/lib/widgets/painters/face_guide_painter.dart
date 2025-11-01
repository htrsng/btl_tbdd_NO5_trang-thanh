// lib/widgets/painters/face_guide_painter.dart
import 'package:flutter/material.dart';

// Đây là class FaceGuidePainter từ file HomeScreen gốc
class FaceGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Oval face
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    //chinh sửa kích thước face

    // Nose
    final nose = Path()
      ..moveTo(size.width * 0.5, size.height * 0.32)
      ..lineTo(size.width * 0.5, size.height * 0.48)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.52,
        size.width * 0.45,
        size.height * 0.52,
      );
    canvas.drawPath(nose, paint);

    // Smile guide
    final smile = Path()
      ..moveTo(size.width * 0.35, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.75,
        size.width * 0.65,
        size.height * 0.65,
      );
    canvas.drawPath(smile, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
