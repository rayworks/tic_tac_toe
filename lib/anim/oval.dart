import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class OvalPaintWidget extends StatefulWidget {
  final int animDurationInSec;

  const OvalPaintWidget({Key? key, this.animDurationInSec = 3})
      : super(key: key);

  @override
  State<OvalPaintWidget> createState() =>
      _OvalPaintWidgetState(animDurationInSec);
}

class _OvalPaintWidgetState extends State<OvalPaintWidget>
    with SingleTickerProviderStateMixin {
  final int animDurationInSec;
  late Animation<double> animation;
  late AnimationController _controller;

  _OvalPaintWidgetState(this.animDurationInSec);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: animDurationInSec),
    );

    Tween<double> _tween = Tween(begin: 0, end: 2 * math.pi);

    animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: OvalPainter(animation.value));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var path = Path();

    final oval = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: 20);
    path.addArc(oval, 0, radians);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  final double radians;

  OvalPainter(this.radians);
}
