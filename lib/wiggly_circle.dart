import 'package:flutter/material.dart';
import 'package:wiggly_circle/movement_rule.dart';
import 'package:wiggly_circle/src/wiggly_circle_painter.dart';
import 'package:wiggly_circle/src/wiggly_circle_point.dart';

class WigglyCircle extends StatefulWidget {
  final int numberOfPoints;
  final WigglyCircleMovementRule movementRule;
  final Color color;
  final double strokeWidth;

  const WigglyCircle({
    Key key,
    this.numberOfPoints = 5,
    this.movementRule = const WigglyCircleMovementRule(),
    this.color = Colors.red,
    this.strokeWidth = 3,
  }) : super(key: key);

  @override
  _WigglyCircleState createState() => _WigglyCircleState();
}

class _WigglyCircleState extends State<WigglyCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final List<WigglyCirclePoint> points = [];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _animation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: WigglyCirclePainter(
            points,
            numberOfPoints: widget.numberOfPoints,
            movementRule: widget.movementRule,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      );
}
