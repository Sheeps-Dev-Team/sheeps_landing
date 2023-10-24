import 'package:flutter/material.dart';

import '../../config/constants.dart';

class Preview extends StatelessWidget {
  const Preview({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all($style.insets.$8),
      decoration: BoxDecoration(
        border: Border.all(color: $style.colors.grey, width: 1 * sizeUnit),
        borderRadius: BorderRadius.circular($style.insets.$12),
      ),
      child: child,
    );
  }
}

enum PreviewItemType { name, title01, text01, img01, button01 }

class PreviewItem extends StatefulWidget {
  const PreviewItem({
    super.key,
    required this.isTwinkle,
    required this.previewItemType,
    required this.color,
    this.isShow = true,
  });

  final bool isTwinkle;
  final PreviewItemType previewItemType;

  final Color color;
  final bool isShow;

  @override
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

  late final double width;
  late final double height;

  @override
  void initState() {
    super.initState();

    switch (widget.previewItemType) {
      case PreviewItemType.name:
        width = 40 * sizeUnit;
        height = 8 * sizeUnit;
        break;
      case PreviewItemType.title01:
        width = 40 * sizeUnit;
        height = 8 * sizeUnit;
        break;
      case PreviewItemType.text01:
        width = 40 * sizeUnit;
        height = 4 * sizeUnit;
        break;
      case PreviewItemType.img01:
        width = 60 * sizeUnit;
        height = 40 * sizeUnit;
        break;
      case PreviewItemType.button01:
        width = 12 * sizeUnit;
        height = 5 * sizeUnit;
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTwinkle) {
      return FadeTransition(
        opacity: _animation,
        child: item(),
      );
    } else {
      return item();
    }
  }

  Widget item() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(widget.isShow ? 1 : .2),
        borderRadius: BorderRadius.circular($style.corners.$4),
      ),
    );
  }
}