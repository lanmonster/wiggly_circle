import 'dart:ui';

import 'package:test/test.dart';
import 'package:wiggly_circle/movement_rule.dart';
import 'package:wiggly_circle/src/wiggly_circle_point.dart';

void main() {
  const movementRule = WigglyCircleMovementRule(
    minRadius: 0,
    radius: 1,
    maxRadius: 2,
  );

  group('Wiggly Circle Point', () {
    test('should be an Offset', () {
      final testObject = WigglyCirclePoint.fromCenter(
        center: Offset.zero,
        theta: 0,
        movementRule: movementRule,
      );
      expect(testObject is Offset, isTrue);
    });
    test('should calculate point on circle given center and angle', () {
      final testObject = WigglyCirclePoint.fromCenter(
        center: Offset.zero,
        theta: 0,
        movementRule: movementRule,
      );
      expect(testObject, Offset(1, 0));
    });
    test('should expose radius', () {
      expect(
        WigglyCirclePoint.fromCenter(
          center: Offset.zero,
          theta: 0,
          movementRule: movementRule,
        ).radius,
        movementRule.radius,
      );
    });
    group('move function', () {
      test('should change the radius', () {
        final expected = WigglyCirclePoint.fromCenter(
          center: Offset.zero,
          theta: 0,
          movementRule: movementRule.copyWith(radius: 0),
        );
        final actual = WigglyCirclePoint.fromCenter(
          center: Offset.zero,
          theta: 0,
          movementRule: movementRule,
        ).move();

        expect(actual, expected);
      });
    });
  });
}
