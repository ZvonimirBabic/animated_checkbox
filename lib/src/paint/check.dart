import 'package:flutter/material.dart';

/// Check code copied and modified from https://pub.dev/packages/msh_checkbox

class Check extends StatelessWidget {
  final double size;
  final double checkAnimation;
  final double strokeWidth;
  final Color color;

  const Check({
    Key? key,
    required this.size,
    required this.checkAnimation,
    required this.strokeWidth,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckPainter(
        checkAnimation: checkAnimation,
        strokeWidth: strokeWidth,
        color: color,
      ),
      size: Size(size, size),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double checkAnimation;
  final double strokeWidth;
  final Color color;

  _CheckPainter({
    required this.checkAnimation,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const corner = 0.3;
    final path = Path();
    final centerAdjustment = corner / 2 * size.height;

    final segment1Scale = checkAnimation < corner ? checkAnimation / corner : 1;
    final segment2Scale = (checkAnimation - corner) / (1 - corner);

    path.moveTo(0, (1 - corner) * size.height - centerAdjustment);

    if (checkAnimation > 0) {
      path.lineTo(
        corner * size.width * segment1Scale,
        (1 - corner) * size.height +
            corner * segment1Scale * size.height -
            centerAdjustment,
      );
    }

    if (checkAnimation > corner) {
      path.lineTo(
        corner * size.width + (1 - corner) * size.width * segment2Scale,
        size.height -
            (1 - corner) * size.height * segment2Scale -
            centerAdjustment,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return checkAnimation != oldDelegate.checkAnimation;
  }
}
