import 'package:flutter_test/flutter_test.dart';
import 'package:wiggly_circle/movement_rule.dart';

void main() {
  group('Wiggly Circle Movement Rule', () {
    test('should have defaults for all parameters', () {
      const expected = WigglyCircleMovementRule(
        minRadius: 135,
        radius: 150,
        maxRadius: 165,
        direction: Direction.IN,
        amountToMove: 1,
      );
      const actual = WigglyCircleMovementRule();

      expect(actual, expected);
    });
    test('should assert that min <= radius <= max', () {
      expect(
        () => WigglyCircleMovementRule(
          minRadius: 3,
          radius: 2,
          maxRadius: 1,
        ),
        throwsAssertionError,
      );
    });
    test('should assert that amountToMove is positive and nonzero', () {
      expect(
        () => WigglyCircleMovementRule(amountToMove: 0),
        throwsAssertionError,
      );
      expect(
        () => WigglyCircleMovementRule(amountToMove: -1),
        throwsAssertionError,
      );
    });
    test('should allow to copy and update radius and movement direction', () {
      const expected = WigglyCircleMovementRule(
        minRadius: 135,
        radius: 140,
        maxRadius: 165,
        direction: Direction.OUT,
        amountToMove: 1,
      );
      final actual = WigglyCircleMovementRule().copyWith(
        radius: expected.radius,
        direction: expected.direction,
      );
      expect(actual, expected);
    });
    group('move function', () {
      test('should decrease the radius if the direction is IN', () {
        const expected = WigglyCircleMovementRule(radius: 149);
        final actual = WigglyCircleMovementRule().move();

        expect(actual, expected);
      });
      test('should increase the radius if the direction is OUT', () {
        const expected = WigglyCircleMovementRule(
          radius: 151,
          direction: Direction.OUT,
        );
        final actual = WigglyCircleMovementRule(
          direction: Direction.OUT,
        ).move();

        expect(actual, expected);
      });
      test('should set direction to IN if radius is greater than max', () {
        const expected = WigglyCircleMovementRule(
          maxRadius: 150,
          direction: Direction.IN,
        );
        final actual = WigglyCircleMovementRule(
          maxRadius: 150,
          direction: Direction.OUT,
        ).move();

        expect(actual.direction, expected.direction);
      });
      test('should set direction to OUT if radius is less than min', () {
        const expected = WigglyCircleMovementRule(
          minRadius: 150,
          direction: Direction.OUT,
        );
        final actual = WigglyCircleMovementRule(
          minRadius: 150,
          direction: Direction.IN,
        ).move();

        expect(actual.direction, expected.direction);
      });
      test('should not update direction if radius in bounds going OUT', () {
        const expected = WigglyCircleMovementRule(
          direction: Direction.OUT,
        );
        final actual = WigglyCircleMovementRule(
          direction: Direction.OUT,
        ).move();

        expect(actual.direction, expected.direction);
      });
      test('should not update direction if radius in bounds going IN', () {
        const expected = WigglyCircleMovementRule(
          direction: Direction.IN,
        );
        final actual = WigglyCircleMovementRule(
          direction: Direction.IN,
        ).move();

        expect(actual.direction, expected.direction);
      });
    });
  });
}
