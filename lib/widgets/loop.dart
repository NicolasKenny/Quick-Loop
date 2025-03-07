import 'package:flutter/cupertino.dart';
import 'package:quick_loop/painter/loop_painter.dart';

class Loop extends ImplicitlyAnimatedWidget {
  final double stroke;
  final double startAngle;
  final double angle;
  final Color color;
  final Widget? child;

  const Loop({
    Key? key,
    required this.stroke,
    required this.startAngle,
    required this.angle,
    required this.color,
    this.child,
    required Duration duration,
    Curve curve = Curves.ease,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
        );

  @override
  _LoopState createState() => _LoopState();
}

class _LoopState extends ImplicitlyAnimatedWidgetState<Loop> {
  Tween<double>? loopStartAngle;
  Tween<double>? loopLength;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LoopPainter(
        stroke: widget.stroke,
        startAngle: loopStartAngle?.evaluate(animation) ?? widget.startAngle,
        angle: loopLength?.evaluate(animation) ?? widget.angle,
        color: widget.color,
      ),
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    loopStartAngle = visitor(loopStartAngle, widget.startAngle,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>;

    loopLength = visitor(loopLength, widget.angle,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>;
  }
}
