import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/login/controllers/login_page_controller.dart';

import '../../config/constants.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/custom_button.dart';
import '../../util/components/custom_text_field.dart';
import '../../util/components/site_app_bar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginPageController controller = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: GetBuilder<LoginPageController>(
        builder: (_) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(GlobalAssets.svgLogo),
                  Text('LANDING', style: $style.text.headline24.copyWith(color: $style.colors.primary, fontWeight: FontWeight.w900),),
                  SizedBox(height: 24 * sizeUnit),
                  Container(
                    width: 200 * sizeUnit,
                    height: 240 * sizeUnit,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12 * sizeUnit),
                        border: Border.all(color: $style.colors.darkGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(GlobalAssets.svgGoogleLogo, width: 26 * 4 * sizeUnit, height:  26 * 4 * sizeUnit,),
                          SizedBox(height: 24 * sizeUnit),
                          CustomButton(
                            width: 180 * sizeUnit,
                            customButtonStyle: CustomButtonStyle.filled48,
                            text: '구글 로그인 \n or 가입하기',
                            isOk: true,
                            color: $style.colors.primary,
                            onTap: () async {
                              await controller.loginFunc();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            )
          );
        },
      ),
    );
  }
}
