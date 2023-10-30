

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/user/user_close_page.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';

import '../../config/constants.dart';
import '../../data/global_data.dart';

class UserSettingPage extends StatelessWidget {
  const UserSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: $style.colors.lightGrey,
        padding: EdgeInsets.all(16 * sizeUnit),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('계정 설정', style: $style.text.headline32,),
            Text('계정 정보, 프로필 등 정보를 확인 및 업데이트 하세요',style: $style.text.body16,),
            Gap(24 * sizeUnit),
            Container(
              width: double.infinity,
              height: 240 * sizeUnit,
              padding: EdgeInsets.all(16 * sizeUnit),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8 * sizeUnit),
                    border: Border.all(color: $style.colors.lightGrey)
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 40 * sizeUnit,
                      child: Text('계정 정보', style: $style.text.subTitle20,)),
                  Divider(height: 1,thickness: 2 * sizeUnit, color: $style.colors.lightGrey,),
                  Gap(12 * sizeUnit),
                  Text('이름', style: $style.text.subTitle16,),
                  Gap(4 * sizeUnit),
                  Container(
                    width: 280 * sizeUnit,
                    height: 38 * sizeUnit,
                    padding: EdgeInsets.all(8 * sizeUnit),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4 * sizeUnit),
                        border: Border.all(color: $style.colors.barrierColor)
                    ),
                    child: Text(GlobalData.loginUser!.name, style: $style.text.body14,),
                  ),
                  Gap(12 * sizeUnit),
                  Row(
                    children: [
                      Text('로그인 이메일', style: $style.text.subTitle16,),
                      Gap(8 * sizeUnit),
                      SvgPicture.asset(GlobalAssets.svgGoogleLogo)
                    ],
                  ),
                  Gap(4 * sizeUnit),
                  Container(
                    width: 280 * sizeUnit,
                    height: 38 * sizeUnit,
                    padding: EdgeInsets.all(8 * sizeUnit),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4 * sizeUnit),
                        border: Border.all(color: $style.colors.barrierColor)
                    ),
                    child: Text(GlobalData.loginUser!.email, style: $style.text.body14,),
                  )
                ],
              ),
            ),
            Gap(24 * sizeUnit),
            Container(
              width: double.infinity,
              height: 180 * sizeUnit,
              padding: EdgeInsets.all(16 * sizeUnit),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8 * sizeUnit),
                  border: Border.all(color: $style.colors.lightGrey)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 40 * sizeUnit,
                      child: Text('계정 닫기', style: $style.text.subTitle20,)),
                  Divider(height: 1,thickness: 2 * sizeUnit, color: $style.colors.lightGrey,),
                  Gap(30 * sizeUnit),
                  Row(
                    children: [
                      SizedBox(
                          width : 600 * sizeUnit,
                          child: Text("Sheeps Landing 계정을 닫기 전에 먼저 계정 내 모든 사이트를 휴지통으로 이동해주세요. Sheeps Landing 계정을 닫기 전에 먼저 계정 내 모든 사이트를 휴지통으로 이동해주세요. ",overflow: TextOverflow.clip,)),
                      const Spacer(),
                      Container(
                        width: 90 * sizeUnit,
                        height: 28 * sizeUnit,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(32 * sizeUnit),
                            border: Border.all(color: $style.colors.red)
                        ),
                        child: TextButton(
                            onPressed: () {
                              Get.to(() => UserClosePage());
                        }, child: Text('계정 닫기',style: $style.text.subTitle14.copyWith(color: $style.colors.red),)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
