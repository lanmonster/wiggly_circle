library wiggly_circle;

import 'package:equatable/equatable.dart';

enum Direction { IN, OUT }

class WigglyCircleMovementRule extends Equatable {
  final double minRadius;
  final double radius;
  final double maxRadius;
  final double amountToMove;
  final Direction direction;

  const WigglyCircleMovementRule({
    this.minRadius = 135,
    this.radius = 150,
    this.maxRadius = 165,
    this.amountToMove = 1,
    this.direction = Direction.IN,
  })  : assert(minRadius <= radius),
        assert(radius <= maxRadius),
        assert(amountToMove > 0);

  @override
  List<Object> get props => [
        minRadius,
        radius,
        maxRadius,
        amountToMove,
        direction,
      ];

  WigglyCircleMovementRule copyWith({
    double radius,
    Direction direction,
  }) =>
      WigglyCircleMovementRule(
        minRadius: minRadius,
        maxRadius: maxRadius,
        radius: radius ?? this.radius,
        direction: direction ?? this.direction,
      );

  WigglyCircleMovementRule move() => (direction == Direction.OUT)
      ? _moveOut(amountToMove)
      : _moveIn(amountToMove);

  WigglyCircleMovementRule _moveOut(double distance) =>
      (radius + distance > maxRadius)
          ? copyWith(radius: radius - distance, direction: Direction.IN)
          : copyWith(radius: radius + distance);

  WigglyCircleMovementRule _moveIn(double distance) =>
      (radius - distance < minRadius)
          ? copyWith(radius: radius + distance, direction: Direction.OUT)
          : copyWith(radius: radius - distance);
}
