import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/user/user_close_page.dart';

import '../../config/constants.dart';
import '../../data/global_data.dart';
import '../../util/components/responsive.dart';

class UserSettingPage extends StatelessWidget {
  const UserSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '계정 설정',
              style: isDesktop ? $style.text.headline32 : $style.text.headline20,
            ),
            Text(
              '계정 정보, 프로필 등 정보를 확인 및 업데이트 하세요',
              style: isDesktop ? $style.text.body16 : $style.text.body12,
            ),
            Gap(isDesktop ? $style.insets.$24 : $style.insets.$12),
            Container(
              width: double.infinity,
              height: 240 * sizeUnit,
              padding: EdgeInsets.all($style.insets.$16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular($style.corners.$8),
                border: Border.all(color: $style.colors.lightGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '계정 정보',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      )),
                  Divider(
                    height: 1,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                  Gap($style.insets.$12),
                  Text(
                    '이름',
                    style: isDesktop ? $style.text.subTitle16 : $style.text.subTitle14,
                  ),
                  Gap($style.insets.$4),
                  Container(
                    width: 280 * sizeUnit,
                    height: isDesktop ? 38 * sizeUnit : 34 * sizeUnit,
                    padding: EdgeInsets.all($style.insets.$8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular($style.corners.$4),
                      border: Border.all(color: $style.colors.barrierColor),
                    ),
                    child: Text(
                      GlobalData.loginUser!.name,
                      style: isDesktop ? $style.text.body14 : $style.text.body12,
                    ),
                  ),
                  Gap($style.insets.$12),
                  Row(
                    children: [
                      Text(
                        '로그인 이메일',
                        style: isDesktop ? $style.text.subTitle16 : $style.text.subTitle14,
                      ),
                      Gap($style.insets.$8),
                      SvgPicture.asset(
                        GlobalAssets.svgGoogleLogo,
                        width: isDesktop ? 24 * sizeUnit : 18 * sizeUnit,
                      ),
                    ],
                  ),
                  Gap($style.insets.$4),
                  Container(
                    width: 280 * sizeUnit,
                    height: isDesktop ? 38 * sizeUnit : 34 * sizeUnit,
                    padding: EdgeInsets.all($style.insets.$8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular($style.corners.$4),
                      border: Border.all(color: $style.colors.barrierColor),
                    ),
                    child: Text(
                      GlobalData.loginUser!.email,
                      style: isDesktop ? $style.text.body14 : $style.text.body12,
                    ),
                  )
                ],
              ),
            ),
            Gap($style.insets.$24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all($style.insets.$16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular($style.corners.$8),
                border: Border.all(color: $style.colors.lightGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '계정 닫기',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      )),
                  Divider(
                    height: 1,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                  Gap($style.insets.$12),
                  if (isDesktop) ...{
                    Row(
                      children: [
                        SizedBox(
                            width: 600 * sizeUnit,
                            child: const Text(
                              "Sheeps Landing 계정을 닫기 전에 먼저 계정 내 모든 사이트를 휴지통으로 이동해주세요.",
                              overflow: TextOverflow.clip,
                            )),
                        const Spacer(),
                        Container(
                          width: 90 * sizeUnit,
                          height: 28 * sizeUnit,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular($style.corners.$32),
                            border: Border.all(color: $style.colors.red),
                          ),
                          child: TextButton(
                              onPressed: () {
                                Get.to(() => UserClosePage());
                              },
                              child: Text(
                                '계정 닫기',
                                style: $style.text.subTitle14.copyWith(color: $style.colors.red),
                              )),
                        )
                      ],
                    )
                  } else if (!isDesktop) ...{
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 600 * sizeUnit,
                            child: Text(
                              "Sheeps Landing 계정을 닫기 전에 먼저 계정 내 모든 사이트를 휴지통으로 이동해주세요.",
                              style: $style.text.body12,
                              overflow: TextOverflow.clip,
                            )),
                        Gap($style.insets.$8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 90 * sizeUnit,
                            height: 28 * sizeUnit,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular($style.corners.$32),
                              border: Border.all(color: $style.colors.red),
                            ),
                            child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all($style.colors.red.withOpacity(0.1)),
                                ),
                                onPressed: () {
                                  Get.to(() => UserClosePage());
                                },
                                child: Text(
                                  '계정 닫기',
                                  style: $style.text.subTitle14.copyWith(color: $style.colors.red),
                                )),
                          ),
                        )
                      ],
                    ),
                  },
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
