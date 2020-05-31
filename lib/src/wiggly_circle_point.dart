import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:wiggly_circle/src/extensions.dart';
import 'package:wiggly_circle/movement_rule.dart';

class WigglyCirclePoint extends Offset {
  final double _theta;
  final Offset _center;
  final WigglyCircleMovementRule _movementRule;

  WigglyCirclePoint._create({
    @required Offset offset,
    @required Offset center,
    @required double theta,
    @required WigglyCircleMovementRule movementRule,
  })  : _center = center,
        _theta = theta,
        _movementRule = movementRule,
        super(offset.dx, offset.dy);

  factory WigglyCirclePoint.fromCenter({
    @required Offset center,
    @required double theta,
    @required WigglyCircleMovementRule movementRule,
  }) =>
      WigglyCirclePoint._create(
        offset: center.pointOnCircumference(
          radius: movementRule.radius,
          theta: theta,
        ),
        center: center,
        theta: theta,
        movementRule: movementRule,
      );

  double get radius => _movementRule.radius;

  WigglyCirclePoint move() => WigglyCirclePoint.fromCenter(
        center: _center,
        theta: _theta,
        movementRule: _movementRule.move(),
      );

  @override
  String toString() {
    return 'WigglyCirclePoint{_theta: $_theta, _center: $_center, _movementRule: $_movementRule}';
  }
}
