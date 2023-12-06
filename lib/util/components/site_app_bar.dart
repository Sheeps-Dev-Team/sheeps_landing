import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../config/routes.dart';
import '../../screens/user/user_main_page.dart';
import 'custom_app_bar.dart';

class SiteAppBar extends StatelessWidget implements PreferredSize {
  const SiteAppBar({super.key, this.leading, this.centerTitle = false});

  final Widget? leading;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktopToFont(context);

    return CustomAppBar(
      leading: leading ?? const SizedBox.shrink(),
      leadingWidth: leading == null ? 24 * sizeUnit : 40 * sizeUnit,
      centerTitle: centerTitle,
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
                        right: isDesktop ? 24 * sizeUnit : 0,
                        child: Container(
                            width: isDesktop ? 240 * sizeUnit : 160 * sizeUnit,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular($style.insets.$14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 4),
                                  blurRadius: 16 * sizeUnit,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all($style.insets.$12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultTextStyle(
                                    style: isDesktop ? $style.text.headline20 : $style.text.headline16,
                                    child: Text(GlobalData.loginUser!.name),
                                  ),
                                  Gap(isDesktop ? $style.insets.$10 : $style.insets.$6),
                                  Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                  Gap(isDesktop ? $style.insets.$10 : $style.insets.$6),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => const UserMainPage());
                                    },
                                    child: Text(
                                      '계정 설정',
                                      style: isDesktop ? $style.text.subTitle14 : $style.text.subTitle10,
                                    ),
                                  ),
                                  Gap($style.insets.$8),
                                  if (Get.currentRoute != Routes.home) ...[
                                    TextButton(
                                      onPressed: () {
                                        Get.offAllNamed(Routes.home);
                                      },
                                      child: Text(
                                        '나의 프로젝트',
                                        style: isDesktop ? $style.text.subTitle14 : $style.text.subTitle10,
                                      ),
                                    ),
                                    Gap($style.insets.$8),
                                  ],
                                  Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                  Gap($style.insets.$16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: isDesktop ? 80 * sizeUnit : 70 * sizeUnit,
                                      height: 30 * sizeUnit,
                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.primary),),
                                      child: TextButton(
                                          onPressed: GlobalFunction.logout,
                                          child: Text(
                                            '로그아웃',
                                            style: isDesktop ? $style.text.subTitle14.copyWith(color: $style.colors.primary) : $style.text.subTitle10.copyWith(color: $style.colors.primary),
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
            child: SvgPicture.asset(
              GlobalAssets.svgProfile,
              width: isDesktop ? 32 * sizeUnit : 24 * sizeUnit,
            ),
          ),
        } else ...{
          Container(
            width: 58 * sizeUnit,
            height: 30 * sizeUnit,
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.primary)),
            child: TextButton(
                onPressed: () => Get.toNamed(Routes.login),
                child: Text(
                  '로그인',
                  style: $style.text.subTitle10.copyWith(color: $style.colors.primary),
                )),
          )
        },
        Gap(isDesktop ? $style.insets.$24 : $style.insets.$16),
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
