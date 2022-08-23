import 'package:flutter/material.dart';

mixin ScaleAnimationMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  double scaleFrom = 1.0, scaleTo = 0.7;
  double partition = 0.5;
  Duration duration = kThemeChangeDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
            tween: Tween(begin: scaleFrom, end: scaleTo), weight: partition),
        TweenSequenceItem<double>(
            tween: Tween(begin: scaleTo, end: scaleFrom), weight: partition),
      ],
    ).animate(_controller);
  }

  void animate() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
