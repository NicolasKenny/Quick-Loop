import 'package:flutter/material.dart';
import 'package:quick_loop/utils/convertor.dart';

class LoopPainter extends CustomPainter {
  final double stroke;
  final double startAngle;
  final double angle;
  final Color color;

  LoopPainter({
    required this.stroke,
    required this.startAngle,
    required this.angle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final path = Path()
      ..arcTo(
        Rect.fromCenter(
          center: center,
          width: size.width,
          height: size.height,
        ),
        degToRad(startAngle),
        degToRad(angle),
        true,
      );

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LoopPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.color != color ||
        oldDelegate.stroke != stroke;
  }
}
