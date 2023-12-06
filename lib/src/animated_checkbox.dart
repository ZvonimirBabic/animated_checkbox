import 'dart:ui';

import 'package:animated_checkbox/src/paint/check.dart';
import 'package:animated_checkbox/src/paint/end_animation_painter.dart';
import 'package:animated_checkbox/src/paint/line_painter.dart';
import 'package:flutter/material.dart';

class AnimatedCheckbox extends StatefulWidget {
  const AnimatedCheckbox({
    Key? key,
    required this.value,
    this.isDisabled = false,
    this.duration = const Duration(milliseconds: 800),
    this.childPadding = const EdgeInsets.only(left: 8.0),
    this.checkboxSize = 30,
    this.checkColor = Colors.green,
    this.lineColor = Colors.black,
    this.animationCurve = Curves.linear,
    required this.onChanged,
    required this.child,
  }) : super(key: key);

  /// Defines checkbox state, can be true or false
  final bool value;

  /// Defines if checkbox is disabled or not
  final bool isDisabled;

  /// Defines checkbox animation duration from start to finish
  final Duration? duration;

  /// Defines checkbox size
  final double checkboxSize;

  /// Defines check color
  final Color checkColor;

  /// Defines line color
  final Color lineColor;

  /// Defines animation curve
  final Curve animationCurve;

  /// Defines onChanged function that gets called when the value changes
  final void Function(bool selected) onChanged;

  /// Defines child padding
  final EdgeInsets childPadding;

  /// Defines a child that will get crossed out
  final Widget child;

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  double get _strokeWidth => 2;

  late final animationController = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didUpdateWidget(covariant AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.duration = widget.duration;

    if (widget.value != oldWidget.value) {
      if (widget.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isDisabled) {
          widget.onChanged(!widget.value);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.checkboxSize),
        child: _AnimatedCheckbox(
          isDisabled: widget.isDisabled,
          animationController: animationController,
          strokeWidth: _strokeWidth,
          checkboxSize: widget.checkboxSize,
          checkColor: widget.checkColor,
          lineColor: widget.lineColor,
          animationCurve: widget.animationCurve,
          childPadding: widget.childPadding,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  _AnimatedCheckbox({
    Key? key,
    required this.isDisabled,
    required this.animationController,
    required this.strokeWidth,
    required this.checkboxSize,
    required this.checkColor,
    required this.lineColor,
    required this.animationCurve,
    required this.childPadding,
    required this.child,
  })  : endAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.7,
              1,
              curve: Curves.easeInCubic,
            ),
          ),
        ),
        checkAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.3,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        lineAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0,
              0.8,
              curve: Curves.easeIn,
            ),
          ),
        ),
        lineAnimationEnd = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.8,
              1,
              curve: Curves.easeOut,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> animationController;
  final bool isDisabled;
  final double strokeWidth;
  final double checkboxSize;
  final Color lineColor;
  final Color checkColor;
  final Curve animationCurve;
  final Widget? child;
  final EdgeInsets childPadding;

  final Animation<double> endAnimation;
  final Animation<double> checkAnimation;
  final Animation<double> lineAnimation;
  final Animation<double> lineAnimationEnd;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) {
        return Row(
          children: [
            Flexible(
              child: Stack(
                alignment: Alignment.centerLeft,
                fit: StackFit.loose,
                children: [
                  Positioned(
                    child: EndAnimation(
                        size: checkboxSize,
                        endAnimation: endAnimation.value,
                        isReverse: animationController.status ==
                            AnimationStatus.reverse,
                        strokeWidth: strokeWidth,
                        color: checkColor),
                  ),
                  Positioned(
                    left: checkboxSize * 0.3,
                    child: Check(
                        size: checkboxSize * 0.4,
                        checkAnimation: checkAnimation.value,
                        strokeWidth: strokeWidth,
                        color: checkColor),
                  ),
                  Positioned.fill(
                    child: LinePainter(
                      lineColor: lineColor,
                      lineAnimation: lineAnimation.value,
                      lineAnimationEnd: lineAnimationEnd.value,
                      strokeWidth: strokeWidth,
                      childPaddingLeft: childPadding.left,
                      childPaddingRight: childPadding.right,
                      checkboxSize: checkboxSize,
                    ),
                  ),
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: lineAnimation.value * 0.8,
                      sigmaY: lineAnimation.value * 0.8,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: checkboxSize),
                      child: Padding(
                        padding: childPadding,
                        child: child,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
