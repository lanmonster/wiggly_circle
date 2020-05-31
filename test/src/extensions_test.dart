import 'dart:math';
import 'dart:ui';

import 'package:test/test.dart';
import 'package:wiggly_circle/src/extensions.dart';

void main() {
  group("Offset Extensions", () {
    test('should calculate a point on the circumference of a circle', () {
      final cases = <Offset, double>{
        Offset(1, 0): 0,
        Offset(sqrt(3) / 2, 1 / 2): pi / 6,
        Offset(sqrt(2) / 2, sqrt(2) / 2): pi / 4,
        Offset(1 / 2, sqrt(3) / 2): pi / 3,
        Offset(0, 1): pi / 2,
        Offset(-1 / 2, sqrt(3) / 2): (2 * pi) / 3,
        Offset(-sqrt(2) / 2, sqrt(2) / 2): (3 * pi) / 4,
        Offset(-sqrt(3) / 2, 1 / 2): (5 * pi) / 6,
        Offset(-1, 0): pi,
        Offset(-sqrt(3) / 2, -1 / 2): (7 * pi) / 6,
        Offset(-sqrt(2) / 2, -sqrt(2) / 2): (5 * pi) / 4,
        Offset(-1 / 2, -sqrt(3) / 2): (4 * pi) / 3,
        Offset(-0, -1): (3 * pi) / 2,
        Offset(1 / 2, -sqrt(3) / 2): (5 * pi) / 3,
        Offset(sqrt(2) / 2, -sqrt(2) / 2): (7 * pi) / 4,
        Offset(sqrt(3) / 2, -1 / 2): (11 * pi) / 6,
      };

      for (var testCase in cases.entries) {
        final expected = testCase.key;
        final angle = testCase.value;

        final actual = Offset.zero.pointOnCircumference(
          radius: 1,
          theta: angle,
        );

        expect(actual.dx.toStringAsFixed(5), expected.dx.toStringAsFixed(5));
        expect(actual.dy.toStringAsFixed(5), expected.dy.toStringAsFixed(5));
      }
    });
  });
}
