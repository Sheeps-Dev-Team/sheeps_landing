import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sheeps_landing/config/constants.dart';

class GetCachedNetworkImage extends StatelessWidget {
  const GetCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.progressColor,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(color: progressColor ?? $style.colors.primary)),
    );
  }
}
