import 'package:flutter/material.dart';
import 'package:sheeps_landing/config/constants.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.onTap, required this.isChecked, required this.color});

  final Function onTap;
  final bool isChecked;
  final Color color;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return GestureDetector(
          onTap: () async {
            widget.onTap();
            await controller.forward().orCancel;
            await controller.reverse().orCancel;
          },
          child: Transform.scale(
            scale: 1 + animation.value * 2,
            child: Icon(
              Icons.thumb_up,
              size: 32 * sizeUnit,
              color: widget.color,
            ),
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
