import 'package:flutter/material.dart';

import '../../config/constants.dart';

class Preview extends StatelessWidget {
  const Preview({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150 * sizeUnit,
      padding: EdgeInsets.symmetric(vertical: $style.insets.$8),
      decoration: BoxDecoration(
        border: Border.all(color: $style.colors.grey, width: 1 * sizeUnit),
        borderRadius: BorderRadius.circular($style.insets.$12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

enum PreviewItemType { name, title, text, mainImg, subImg, button }

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
    duration: const Duration(milliseconds: 700),
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
      case PreviewItemType.title:
        width = 40 * sizeUnit;
        height = 6 * sizeUnit;
        break;
      case PreviewItemType.text:
        width = 40 * sizeUnit;
        height = 3 * sizeUnit;
        break;
      case PreviewItemType.mainImg:
        width = 60 * sizeUnit;
        height = 32 * sizeUnit;
        break;
      case PreviewItemType.subImg:
        width = 60 * sizeUnit;
        height = 40 * sizeUnit;
        break;
      case PreviewItemType.button:
        width = 12 * sizeUnit;
        height = 5 * sizeUnit;
        break;
      default:
        width = 0;
        height = 0;
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
    int r = (widget.color.red * 0.9).toInt();
    int g = (widget.color.green * 0.9).toInt();
    int b = (widget.color.blue * 0.9).toInt();
    Color color = Color.fromRGBO(r, g, b, 1);

    return Container(
      width: width * 1.2,
      height: height * 1.2,
      decoration: BoxDecoration(
        color: widget.isTwinkle ? Color.lerp(widget.color, color, 0.1) : widget.color.withOpacity(widget.isShow ? 1 : .3),
        borderRadius: BorderRadius.circular($style.corners.$4),
      ),
    );
  }
}
