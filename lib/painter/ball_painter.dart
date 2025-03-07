import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:quick_loop/utils/convertor.dart';

class BallPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double angle;

  BallPainter({
    required this.color,
    required this.radius,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = cos(degToRad(angle)) * (size.width / 2);
    final y = sin(degToRad(angle)) * (size.width / 2);

    final center = size.center(Offset(x, y));

    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: radius * 2,
        ),
      );

    final paint = Paint()..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BallPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.angle != angle;
  }
}
