import 'package:flutter/material.dart';

class EndAnimation extends StatelessWidget {
  final double size;
  final bool isReverse;
  final double endAnimation;
  final double strokeWidth;
  final Color color;

  const EndAnimation({
    Key? key,
    required this.size,
    required this.isReverse,
    required this.endAnimation,
    required this.strokeWidth,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EndAnimationPainter(
        endAnimation: endAnimation,
        strokeWidth: strokeWidth,
        isReverse: isReverse,
        color: color,
      ),
      size: Size(size, size),
    );
  }
}

class _EndAnimationPainter extends CustomPainter {
  final double endAnimation;
  final double strokeWidth;
  final bool isReverse;
  final Color color;

  _EndAnimationPainter({
    required this.endAnimation,
    required this.strokeWidth,
    required this.isReverse,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Declaring paths
    final Path endAnimationPath = Path();

    /// Declaring paint
    final Paint paint = Paint()
      ..color = color.withOpacity(1 - endAnimation)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    /// Size helpers
    final double maxWidth = size.width;
    final double maxHeight = size.height;
    final double halfWidth = maxWidth / 2;
    final double halfHeight = maxHeight / 2;

    endAnimationPath
      ..moveTo(halfWidth, halfHeight)
      ..addOval(
        Rect.fromCenter(
          center: Offset(halfWidth, halfHeight),
          width: endAnimation * size.width,
          height: endAnimation * size.width,
        ),
      );

    canvas.drawPath(isReverse ? Path() : endAnimationPath, paint);
  }

  @override
  bool shouldRepaint(covariant _EndAnimationPainter oldDelegate) {
    return endAnimation != oldDelegate.endAnimation;
  }
}
