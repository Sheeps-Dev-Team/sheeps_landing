import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import 'custom_app_bar.dart';

class SiteAppBar extends StatelessWidget implements PreferredSize{
  const SiteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 24,
      centerTitle: false,
      titleWidget: SvgPicture.asset(GlobalAssets.svgLogo, height: 19),
      actions: [
        Text(
          '로그아웃',
          style: $style.text.subTitle14.copyWith(color: $style.colors.grey),
        ),
        Gap($style.insets.$4),
        SvgPicture.asset(GlobalAssets.svgLogout),
        Gap($style.insets.$24),
      ],
    );
  }

  @override
  // TODO: implement child
  Widget get child => const SizedBox.shrink();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, CustomAppBar.appBarHeight * sizeUnit);
}
