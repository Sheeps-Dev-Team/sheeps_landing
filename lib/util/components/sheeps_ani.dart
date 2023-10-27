import 'package:flutter/material.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class SheepsAniFadeIn extends StatefulWidget {
  const SheepsAniFadeIn({super.key, required this.child, this.direction = Direction.up, this.distance = 0, this.isAction = false});

  final Widget child;
  final Direction direction;
  final double distance;
  final bool isAction;

  @override
  State<SheepsAniFadeIn> createState() => _SheepsAniFadeInState();
}

class _SheepsAniFadeInState extends State<SheepsAniFadeIn> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAction) {
      controller.forward().orCancel;
    }
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (_, child) {
        Matrix4 transform;
        switch (widget.direction) {
          case Direction.up:
            transform = Matrix4.translationValues(0, widget.distance * (1 - animation.value), 0);
          case Direction.down:
            transform = Matrix4.translationValues(0, -widget.distance * (1 - animation.value), 0);
          case Direction.left:
            transform = Matrix4.translationValues(-widget.distance * (1 - animation.value), 0, 0);
          case Direction.right:
            transform = Matrix4.translationValues(widget.distance * (1 - animation.value), 0, 0);
        }
        return Opacity(
          opacity: animation.value,
          child: Transform(
            transform: transform,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
