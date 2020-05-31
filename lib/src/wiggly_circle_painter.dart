import 'dart:math' show Random, pi;

import 'package:flutter/material.dart';
import 'package:wiggly_circle/movement_rule.dart';
import 'package:wiggly_circle/src/wiggly_circle_point.dart';

class WigglyCirclePainter extends CustomPainter {
  static const double _TAU = pi * 2;

  final List<WigglyCirclePoint> points;
  final int numberOfPoints;
  final WigglyCircleMovementRule movementRule;
  final Color color;
  final double strokeWidth;
  final Random _rng;

  WigglyCirclePainter(
    this.points, {
    this.numberOfPoints = 5,
    this.movementRule = const WigglyCircleMovementRule(),
    this.color = Colors.red,
    this.strokeWidth = 3,
    Random rng,
  })  : assert(numberOfPoints > 2),
        assert(points.isEmpty || points.length == numberOfPoints + 1),
        _rng = rng ?? Random(),
        _brush = Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round;

  final Paint _brush;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) _generatePoints(size.center(Offset.zero));

    _moveRandomPoint();

    _drawPointsAsPath(canvas);
  }

  void _generatePoints(Offset center) {
    for (double theta = 0; theta < _TAU; theta += _TAU / numberOfPoints) {
      points.add(WigglyCirclePoint.fromCenter(
        center: center,
        theta: theta,
        movementRule: movementRule,
      ));
    }
    points.add(points.first);
  }

  void _moveRandomPoint() {
    final index = _rng.nextInt(points.length - 1);

    points[index] = points[index].move();

    if (index == 0) points.last = points.last.move();
    if (index == points.length - 1) points.first = points.first.move();
  }

  void _drawPointsAsPath(Canvas canvas) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var point in points.skip(1)) {
      path.arcToPoint(point, radius: Radius.circular(point.radius));
    }
    canvas.drawPath(path, _brush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
