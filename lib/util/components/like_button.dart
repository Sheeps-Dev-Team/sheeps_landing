import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sheeps_landing/config/constants.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.onTap, required this.isChecked, required this.color, required this.count});

  final Function onTap;
  final bool isChecked;
  final Color color;
  final int count;

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
    return InkWell(
      borderRadius: BorderRadius.circular($style.corners.$12),
      onTap: () async {
        widget.onTap();
        await controller.forward().orCancel;
        await controller.reverse().orCancel;
      },
      child: Container(
        width: 68 * sizeUnit,
        height: 68 * sizeUnit,
        // padding: EdgeInsets.all($style.insets.$8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular($style.corners.$12),
          color: Colors.white,
          boxShadow: $style.boxShadows.bs1,
        ),
        child: AnimatedBuilder(
          animation: animation,
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1 + animation.value * 2,
                  child: Icon(
                    Icons.thumb_up,
                    size: 32 * sizeUnit,
                    color: widget.color,
                  ),
                ),
                Gap($style.insets.$4),
                Text(
                  widget.count > 99 ? '99+' : widget.count.toString(),
                  style: $style.text.subTitle12.copyWith(color: widget.color),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
