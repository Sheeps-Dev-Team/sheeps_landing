import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.titleWidget,
    this.centerTitle,
    this.leadingWidth,
    this.controller,
    this.backgroundColor,
    this.surfaceTintColor,
    this.height,
  });

  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final bool? centerTitle;
  final double? leadingWidth;
  final ScrollController? controller;
  final bool showBottomLine = true;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double? height;

  static const appBarHeight = 48;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height ?? appBarHeight * sizeUnit),
      child: GestureDetector(
        onTap: () {
          // if (Platform.isIOS && (controller != null && controller!.positions.isNotEmpty)) {
          //   controller!.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.bounceInOut);
          // }
        },
        child: Column(
          children: [
            AppBar(
              backgroundColor: backgroundColor ?? Colors.white,
              toolbarHeight: height != null ? height! - 1 * sizeUnit : 47 * sizeUnit,
              elevation: 0,
              centerTitle: centerTitle ?? true,
              titleSpacing: 0.0,
              leadingWidth: leadingWidth,
              iconTheme: IconThemeData(color: $style.colors.black),
              leading: leading ?? backButton(),
              title: titleWidget ?? (title != null ? Text(title!, style: $style.text.headline18) : null),
              actions: actions,
              surfaceTintColor: surfaceTintColor,

            ),
            if (showBottomLine)
              Divider(
                height: 1 * sizeUnit,
                thickness: 1 * sizeUnit,
                color: $style.colors.lightGrey,
              ),
            Container(
              width: double.infinity,
              height:0 * sizeUnit,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5 * sizeUnit,
                    blurRadius: 0.5 * sizeUnit,
                    offset: Offset(0, 0), // 그림자의 위치 조정
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return Padding(
      padding: EdgeInsets.only(left: $style.insets.$12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => Get.back(),
          child: SvgPicture.asset(GlobalAssets.svgArrowLeft, width: 24 * sizeUnit),
        ),
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => const SizedBox.shrink();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, height ?? appBarHeight * sizeUnit);
}
