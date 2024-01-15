import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/screens/info/privacy%20_policy_page.dart';
import 'package:sheeps_landing/screens/info/terms_of_service_page.dart';
import 'package:sheeps_landing/screens/login/controllers/login_page_controller.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/routes.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/responsive.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginPageController controller = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return BaseWidget(
      child: GetBuilder<LoginPageController>(
        builder: (_) {
          return Scaffold(
              body: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                GlobalAssets.svgLogo,
                height: isDesktop ? 100 * sizeUnit : 80 * sizeUnit,
              ),
              SizedBox(height: 18 * sizeUnit),
              Text('로그인', style: $style.text.subTitle20),
              SizedBox(height: 12 * sizeUnit),
              InkWell(
                onTap: () async {
                  if (false == await GlobalFunction.globalLogin() && GlobalData.loginUser != null) {
                    //로그인 성공시
                    Get.offAllNamed(Routes.home);
                  } else {
                    //로그인 실패시
                    GlobalFunction.showToast(msg: '로그인 실패');
                  }
                },
                child: Container(
                  width: 240 * sizeUnit,
                  height: 36 * sizeUnit,
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(6 * sizeUnit), border: Border.all(color: $style.colors.barrierColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        GlobalAssets.svgGoogleLogo,
                        width: 24 * sizeUnit,
                        height: 18 * sizeUnit,
                      ),
                      SizedBox(width: 24 * sizeUnit),
                      Text(
                        '구글 계정으로 계속하기',
                        style: $style.text.subTitle14,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18 * sizeUnit),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100 * sizeUnit,
                        child: Divider(
                          height: 0.1 * sizeUnit,
                        )),
                    SizedBox(
                      width: 10 * sizeUnit,
                    ),
                    Text(
                      '또는',
                      style: $style.text.subTitle14.copyWith(color: $style.colors.grey),
                    ),
                    SizedBox(
                      width: 10 * sizeUnit,
                    ),
                    SizedBox(
                        width: 100 * sizeUnit,
                        child: Divider(
                          height: 0.1 * sizeUnit,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 18 * sizeUnit),
              InkWell(
                onTap: () async {
                  Get.offAllNamed(Routes.index);
                },
                child: Container(
                  width: 240 * sizeUnit,
                  height: 36 * sizeUnit,
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(6 * sizeUnit), border: Border.all(color: $style.colors.barrierColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로그인 없이 무료로 계속하기',
                        style: $style.text.subTitle14,
                      )
                    ],
                  ),
                ),
              ),
              Gap($style.insets.$18),
              textWidget(
                  text: '서비스 이용약관',
                  onTap: () {
                    Get.to(() => const TermsOfServicePage());
                  }),
              Gap($style.insets.$8),
              textWidget(
                  text: '개인정보 처리방침',
                  onTap: () {
                    Get.to(() => const PrivacyPolicyPage());
                  }),
            ],
          )));
        },
      ),
    );
  }

//푸터 텍스트버튼 위젯
  InkWell textWidget({required String text, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: $style.text.body14.copyWith(decoration: TextDecoration.underline, decorationColor: $style.colors.darkGrey, color: $style.colors.darkGrey),
      ),
    );
  }
}
