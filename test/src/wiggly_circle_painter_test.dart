import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wiggly_circle/movement_rule.dart';
import 'package:wiggly_circle/src/wiggly_circle_painter.dart';
import 'package:wiggly_circle/src/wiggly_circle_point.dart';

void main() {
  group('Painter', () {
    const size = Size(200, 200);
    Canvas mockCanvas;
    setUp(() {
      mockCanvas = MockCanvas();
    });
    test('should be a custom painter', () {
      expect(WigglyCirclePainter([]), isA<CustomPainter>());
    });
    group('constructor', () {
      test('should have default values', () {
        final testObject = WigglyCirclePainter([]);

        expect(testObject.numberOfPoints, 5);
        expect(testObject.movementRule, WigglyCircleMovementRule());
        expect(testObject.color, Colors.red);
        expect(testObject.strokeWidth, 3);
      });
      test('should assert if points has an incorrect number of values', () {
        expect(
          () => WigglyCirclePainter(
            [
              WigglyCirclePoint.fromCenter(
                center: Offset.zero,
                theta: 0,
                movementRule: WigglyCircleMovementRule(),
              )
            ],
          ),
          throwsAssertionError,
        );
      });
      test('should assert if numberOfPoints is less than 3', () {
        expect(
          () => WigglyCirclePainter([], numberOfPoints: 2),
          throwsAssertionError,
        );
      });
    });
    test('should repaint', () {
      expect(
        WigglyCirclePainter([]).shouldRepaint(WigglyCirclePainter([])),
        isTrue,
      );
    });
    group('paint', () {
      group('generate points', () {
        List<WigglyCirclePoint> points;
        WigglyCirclePainter testObject;
        setUp(() {
          points = [];
          testObject = WigglyCirclePainter(points);
        });
        test('should populate the points list', () {
          testObject.paint(mockCanvas, size);
          expect(points.length, testObject.numberOfPoints + 1);
        });
        test('should not populate if list is already full', () {
          testObject.paint(mockCanvas, size);
          testObject.paint(mockCanvas, size);

          expect(points.length, testObject.numberOfPoints + 1);
        });
        test('first point should be the same as last point', () {
          testObject.paint(mockCanvas, size);

          expect(points.first, points.last);
        });
      });
      group('move random point', () {
        List<WigglyCirclePoint> points;
        WigglyCirclePainter testObject;
        Random mockRandom;

        setUp(() {
          points = [];
          mockRandom = MockRandom();
          when(mockRandom.nextInt(any)).thenReturn(0);
          testObject = WigglyCirclePainter(points, rng: mockRandom);
        });
        test('moves a random point', () {
          testObject.paint(mockCanvas, size);

          expect(points.first.radius, 149);
          verify(mockRandom.nextInt(points.length - 1));
        });
        test('last should equal first when first moves', () {
          testObject.paint(mockCanvas, size);

          expect(points.first, points.last);
        });
        test('last should equal first when last moves', () {
          when(mockRandom.nextInt(any)).thenReturn(5);

          testObject.paint(mockCanvas, size);

          expect(points.first, points.last);
        });
      });
      group('draw points as path', () {
        List<WigglyCirclePoint> points;
        WigglyCirclePainter testObject;
        Random mockRandom;

        setUp(() {
          points = [];
          mockRandom = MockRandom();
          when(mockRandom.nextInt(any)).thenReturn(1);
          testObject = WigglyCirclePainter(points);
        });

        test('should use the correct paint brush', () {
          testObject.paint(mockCanvas, size);

          final captured = verify(mockCanvas.drawPath(
            any,
            captureAny,
          )).captured;

          expect(captured.length, 1);
          expect(captured.first, isA<Paint>());

          final capturedPaint = captured.first as Paint;

          expect(capturedPaint.color.red, testObject.color.red);
          expect(capturedPaint.color.green, testObject.color.green);
          expect(capturedPaint.color.blue, testObject.color.blue);
          expect(capturedPaint.strokeWidth, testObject.strokeWidth);
          expect(capturedPaint.strokeCap, StrokeCap.round);
          expect(capturedPaint.style, PaintingStyle.stroke);
          expect(capturedPaint.strokeJoin, StrokeJoin.round);
        });

        test('should arc to each point', () {
          testObject.paint(mockCanvas, size);

          final expectedPath = Path()
            ..moveTo(
              points.first.dx,
              points.first.dy,
            );
          for (WigglyCirclePoint point in points.skip(1)) {
            expectedPath.arcToPoint(
              point,
              radius: Radius.circular(point.radius),
            );
          }

          final captured =
              verify(mockCanvas.drawPath(captureAny, any)).captured;
          expect(captured.length, 1);
          expect(captured.first, isA<Path>());

          final capturedPath = captured.first as Path;
          expect(capturedPath.getBounds(), expectedPath.getBounds());
        });
      });
    });
  });
}

class MockCanvas extends Mock implements Canvas {}

class MockRandom extends Mock implements Random {}
