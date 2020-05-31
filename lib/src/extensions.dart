import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

extension OffsetX on Offset {
  double _calcX(double radius, double theta) => dx + radius * cos(theta);

  double _calcY(double radius, double theta) => dy + radius * sin(theta);

  Offset pointOnCircumference({
    @required double radius,
    @required double theta,
  }) =>
      Offset(
        _calcX(radius, theta),
        _calcY(radius, theta),
      );
}
