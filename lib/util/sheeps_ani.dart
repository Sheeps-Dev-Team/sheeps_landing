import 'package:flutter/material.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class SheepsFadeInAnimation extends AnimatedWidget {
  const SheepsFadeInAnimation({super.key, required Animation<double> animation, required Widget child, this.direction = Direction.down, this.distance = 0})
      : _child = child,
        super(listenable: animation);

  final Widget _child;
  final Direction direction;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    Matrix4 transform;
    switch (direction) {
      case Direction.up:
        transform = Matrix4.translationValues(0, -distance * (1 - animation.value), 0);
      case Direction.down:
        transform = Matrix4.translationValues(0, distance * (1 - animation.value), 0);
      case Direction.left:
        transform = Matrix4.translationValues(-distance * (1 - animation.value), 0, 0);
      case Direction.right:
        transform = Matrix4.translationValues(distance * (1 - animation.value), 0, 0);
    }
    return Opacity(
      opacity: animation.value,
      child: Transform(
        transform: transform,
        child: _child,
      ),
    );
  }
}
