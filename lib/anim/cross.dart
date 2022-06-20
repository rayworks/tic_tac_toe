import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'path_animator.dart';

class CrossPaintWidget extends StatefulWidget {
  final int animDurationInSec;

  const CrossPaintWidget({Key? key, this.animDurationInSec = 3})
      : super(key: key);

  @override
  State<CrossPaintWidget> createState() =>
      _CrossPaintWidgetState(animDurationInSec);
}

class _CrossPaintWidgetState extends State<CrossPaintWidget>
    with SingleTickerProviderStateMixin {
  final int animDurationInSec;
  late Animation<double> animation;
  late AnimationController _controller;

  _CrossPaintWidgetState(this.animDurationInSec);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: animDurationInSec),
    );

    Tween<double> _rotationTween = Tween(begin: .0, end: 1.0);

    animation = _rotationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CrossPainter(animation.value));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    var sizeCell = Rect.fromLTWH(0, 0, 40, 40);
    path.moveTo(0, 0);
    path.lineTo(sizeCell.width, sizeCell.height);
    path.moveTo(sizeCell.width, 0);
    path.lineTo(0, sizeCell.height);

    final animatedPath = PathAnimator.build(
      path: path.shift(Offset(-20, -20)),
      animationPercent: progress,
    );

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  final double progress;

  CrossPainter(this.progress);
}
