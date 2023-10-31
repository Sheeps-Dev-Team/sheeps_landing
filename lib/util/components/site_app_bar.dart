import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/screens/user/user_setting_page.dart';
import 'package:sheeps_landing/util/components/responsive.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../config/routes.dart';
import '../../data/models/user.dart';
import 'custom_app_bar.dart';

class SiteAppBar extends StatelessWidget implements PreferredSize{
  const SiteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 24 * sizeUnit,
      centerTitle: false,
      titleWidget: SvgPicture.asset(GlobalAssets.svgLogo, height: 36 * sizeUnit),
      actions: [
        if(GlobalData.loginUser != null) ... {
          InkWell(
              onTap: () {
                Get.dialog(
                   Center(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 48 * sizeUnit,
                          right: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.1 : 0,
                          child: Container(
                            width: 240 * sizeUnit,
                            height: 208 * sizeUnit,
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
                                  Text('국양봉', style: $style.text.headline24,),
                                  Gap(8 * sizeUnit),
                                  Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                  Gap(8 * sizeUnit),
                                  TextButton(onPressed: () {
                                    Get.to(() => const UserSettingPage());
                                  }, child: Text('계정 설정', style: $style.text.subTitle14,),),
                                  Gap(8 * sizeUnit),
                                  TextButton(onPressed: () {
                                    Get.to(() => const UserSettingPage());  //내 앱 페이지로 이동 필요
                                  }, child: Text('나의 앱', style: $style.text.subTitle14,),),
                                  Gap(8 * sizeUnit),
                                  Divider(height: 1, thickness: 2, color: $style.colors.lightGrey),
                                  Gap(16 * sizeUnit),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 80 * sizeUnit,
                                      height: 28 * sizeUnit,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(32 * sizeUnit),
                                          border: Border.all(color: $style.colors.primary)
                                      ),
                                      child: TextButton(
                                          onPressed: () {
                                            GlobalData.loginUser = null;
                                            GlobalData.projectList = [];

                                            //소개 페이지로 이동 필요
                                          },
                                          child: Text('로그아웃',style: $style.text.subTitle14.copyWith(color: $style.colors.primary),)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  barrierColor: Colors.transparent,
                );
              },
              child: SvgPicture.asset(GlobalAssets.svgProfile, width: 32 * sizeUnit)),
        } else ... {

          Container(
            width: 80 * sizeUnit,
            height: 34 * sizeUnit,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32 * sizeUnit),
                border: Border.all(color: $style.colors.primary)
            ),
            child: TextButton(
                onPressed: () => Get.toNamed(Routes.login),child: Text('로그인',style: $style.text.subTitle14.copyWith(color: $style.colors.primary),)),
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
