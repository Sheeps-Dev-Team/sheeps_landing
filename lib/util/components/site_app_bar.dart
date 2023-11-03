import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/screens/user/user_setting_page.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../config/routes.dart';
import '../../data/models/user.dart';
import '../../screens/user/user_main_page.dart';
import 'custom_app_bar.dart';

class SiteAppBar extends StatelessWidget implements PreferredSize {
  const SiteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 24 * sizeUnit,
      centerTitle: false,
      titleWidget: InkWell(onTap: () => Get.toNamed(Routes.index), child: SvgPicture.asset(GlobalAssets.svgLogo, height: 28 * sizeUnit)),
      actions: [
        if (GlobalData.loginUser != null) ...{
          InkWell(
              onTap: () {
                Get.dialog(
                  Center(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 48 * sizeUnit,
                          right: Responsive.isDesktop(context) ? 24 * sizeUnit : 0,
                          child: Container(
                              width: 240 * sizeUnit,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14 * sizeUnit),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 4),
                                    blurRadius: 16 * sizeUnit,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0 * sizeUnit),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultTextStyle(
                                      style: $style.text.headline20,
                                      child: Text(GlobalData.loginUser!.name),
                                    ),
                                    Gap(10 * sizeUnit),
                                    Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                    Gap(10 * sizeUnit),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(() => const UserMainPage());
                                      },
                                      child: Text(
                                        '계정 설정',
                                        style: $style.text.subTitle14,
                                      ),
                                    ),
                                    Gap(8 * sizeUnit),
                                    if (Get.currentRoute != Routes.home) ...[
                                      TextButton(
                                        onPressed: () {
                                          Get.offAllNamed(Routes.home);
                                        },
                                        child: Text(
                                          '나의 프로젝트',
                                          style: $style.text.subTitle14,
                                        ),
                                      ),
                                      Gap(8 * sizeUnit),
                                    ],
                                    Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                    Gap(16 * sizeUnit),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 80 * sizeUnit,
                                        height: 28 * sizeUnit,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent, borderRadius: BorderRadius.circular(32 * sizeUnit), border: Border.all(color: $style.colors.primary)),
                                        child: TextButton(
                                            onPressed: GlobalFunction.logout,
                                            child: Text(
                                              '로그아웃',
                                              style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  barrierColor: Colors.transparent,
                );
              },
              child: SvgPicture.asset(GlobalAssets.svgProfile, width: 32 * sizeUnit)),
        } else ...{
          Container(
            width: 80 * sizeUnit,
            height: 34 * sizeUnit,
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(32 * sizeUnit), border: Border.all(color: $style.colors.primary)),
            child: TextButton(
                onPressed: () => Get.toNamed(Routes.login),
                child: Text(
                  '로그인',
                  style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                )),
          )
        },
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
