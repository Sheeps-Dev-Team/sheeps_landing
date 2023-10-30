import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheeps_landing/config/global_assets.dart';

import '../../config/constants.dart';

class GetExtendedImage extends StatefulWidget {
  const GetExtendedImage({
    Key? key,
    required this.url,
    this.fit = BoxFit.cover,
    this.isZoom = false,
    this.width,
    this.height,
    this.loadingWidget,
  }) : super(key: key);

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool isZoom;
  final Widget? loadingWidget;

  @override
  _GetExtendedImageState createState() => _GetExtendedImageState();
}

class _GetExtendedImageState extends State<GetExtendedImage> with SingleTickerProviderStateMixin {
  late AnimationController extendedController;

  @override
  void initState() {
    extendedController = AnimationController(vsync: this, duration: const Duration(seconds: 1), lowerBound: 0.0, upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    extendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) return const SizedBox.shrink();

    if (widget.isZoom) {
      return ExtendedImage.network(
        widget.url,
        fit: widget.fit,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) {
          return GestureConfig(
            minScale: 0.9,
            animationMinScale: 0.7,
            maxScale: 3.0,
            animationMaxScale: 3.5,
            speed: 1.0,
            inertialSpeed: 100.0,
            initialScale: 1.0,
            inPageView: false,
            initialAlignment: InitialAlignment.center,
          );
        },
      );
    }

    return ExtendedImage.network(
      widget.url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            extendedController.reset();
          return widget.loadingWidget ?? Center(
            child: SizedBox(
              width: 24 * sizeUnit,
              height: 24 * sizeUnit,
              child: CircularProgressIndicator(strokeWidth: 2 * sizeUnit, color: $style.colors.primary),
            ),
          );
          case LoadState.completed:
            extendedController.forward();
            return FadeTransition(
              opacity: extendedController,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                fit: widget.fit,
                alignment: Alignment.center,
              ),
            );
          case LoadState.failed:
            extendedController.reset();
            return Center(
              child: SvgPicture.asset(
                GlobalAssets.svgImg,
                width: 24 * sizeUnit,
                colorFilter: ColorFilter.mode(
                  $style.colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            );
        }
      },
    );
  }
}
