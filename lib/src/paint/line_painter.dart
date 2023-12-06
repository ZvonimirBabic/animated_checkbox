import 'dart:ui';

import 'package:flutter/material.dart';

class LinePainter extends StatelessWidget {
  final double lineAnimation;
  final double lineAnimationEnd;
  final double strokeWidth;
  final double checkboxSize;
  final double childPaddingLeft;
  final double childPaddingRight;
  final Color lineColor;

  const LinePainter({
    Key? key,
    required this.lineAnimation,
    required this.lineAnimationEnd,
    required this.strokeWidth,
    required this.lineColor,
    required this.childPaddingLeft,
    required this.childPaddingRight,
    required this.checkboxSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckboxBorderPainter(
        lineAnimation: lineAnimation,
        lineAnimationEnd: lineAnimationEnd,
        strokeWidth: strokeWidth,
        lineColor: lineColor,
        childPaddingLeft: childPaddingLeft,
        childPaddingRight: childPaddingRight,
        checkboxSize: checkboxSize,
      ),
    );
  }
}

class _CheckboxBorderPainter extends CustomPainter {
  final double lineAnimation;
  final double lineAnimationEnd;
  final double strokeWidth;
  final Color lineColor;
  final double checkboxSize;
  final double childPaddingLeft;
  final double childPaddingRight;

  _CheckboxBorderPainter({
    required this.lineAnimation,
    required this.lineAnimationEnd,
    required this.strokeWidth,
    required this.lineColor,
    required this.childPaddingLeft,
    required this.childPaddingRight,
    this.checkboxSize = 30,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Declaring paths
    final Path rRectPath = Path();
    final Path crosslinePath = Path();

    /// Declaring paint
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    /// Size helpers
    final double maxWidth = size.width;
    final double maxHeight = size.height;
    final double halfHeight = maxHeight / 2;

    /// Checkbox size helpers
    final double checkboxWidth = checkboxSize;
    final double checkboxHeight = checkboxSize;
    final double checkboxHalfWidth = checkboxWidth / 2;
    final double checkboxHalfHeight = checkboxHeight / 2;
    final double checkboxQuarterWidth = checkboxWidth / 4;
    final double checkboxQuarterHeight = checkboxHeight / 4;

    /// Canvas in flutter spans right as a positive X and down as a positive Y coordinate
    /// New Paths always start at X,Y(0,0) which means top left

    /// To achieve the crossing animation and filling the rectangle border
    /// we first need to move the path to a new starting position which is
    /// size.width ( checkboxWidth ) and half of size.height ( checkboxHalfHeight )

    /// To animate the RRect border we have to construct it manually using lines
    /// because RRect does not have a sweep angle like drawArc

    /// Constructs a path without drawing it
    rRectPath
      ..moveTo(checkboxWidth, halfHeight)
      ..relativeLineTo(0, -checkboxQuarterHeight)
      ..relativeQuadraticBezierTo(0, -checkboxQuarterWidth,
          -checkboxQuarterWidth, -checkboxQuarterHeight)
      ..relativeLineTo(-checkboxHalfWidth, 0)
      ..relativeQuadraticBezierTo(-checkboxQuarterHeight, 0,
          -checkboxQuarterWidth, checkboxQuarterHeight)
      ..relativeLineTo(0, checkboxHalfHeight)
      ..relativeQuadraticBezierTo(
          0, checkboxQuarterHeight, checkboxQuarterWidth, checkboxQuarterHeight)
      ..relativeLineTo(checkboxHalfWidth, 0)
      ..relativeQuadraticBezierTo(checkboxQuarterHeight, 0,
          checkboxQuarterWidth, -checkboxQuarterHeight)
      ..relativeLineTo(0, -checkboxQuarterHeight);

    /// Computing path metrics to construct a path to draw
    PathMetric rRectPathMetrics = rRectPath.computeMetrics().first;

    /// Extracting the path between 2 points
    Path extractRRectPath = rRectPathMetrics.extractPath(
        lineAnimation, rRectPathMetrics.length * (1 - lineAnimation));

    /// Drawing a path
    canvas.drawPath(extractRRectPath, paint);

    /// Draws a "crossline" that goes over the child widget
    /// Animation is achieved by using the extractPath property and providing 2
    /// points of a path ( start and end ) based on the animation percentage

    /// Constructs a path without drawing it
    crosslinePath
      ..moveTo(checkboxWidth, halfHeight)
      ..lineTo(maxWidth, halfHeight);

    /// Computing path metrics to construct a path to draw
    PathMetric crosslinePathMetrics = crosslinePath.computeMetrics().first;

    /// Extracting the path between 2 points
    Path extractCrosslinePathMetrics = crosslinePathMetrics.extractPath(
        lineAnimationEnd * childPaddingLeft,
        ((crosslinePathMetrics.length - childPaddingRight) * lineAnimation));

    /// Drawing a path
    canvas.drawPath(extractCrosslinePathMetrics, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
