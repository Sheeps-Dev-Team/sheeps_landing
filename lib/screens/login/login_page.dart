import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/screens/home/controllers/home_page_controller.dart';
import 'package:sheeps_landing/screens/login/controllers/login_page_controller.dart';
import 'package:sheeps_landing/screens/user/user_main_page.dart';
import 'package:sheeps_landing/util/components/get_extended_image.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/routes.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/custom_button.dart';
import '../../util/components/custom_text_field.dart';
import '../../util/components/responsive.dart';
import '../../util/components/site_app_bar.dart';
import '../project/controllers/create_project_controller.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginPageController controller = Get.put(LoginPageController());
  final CreateProjectController createProjectController = Get.put(CreateProjectController());



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
                  SvgPicture.asset(GlobalAssets.svgLogo, height: isDesktop ? 100 * sizeUnit : 80 * sizeUnit,),
                  SizedBox(height: 18 * sizeUnit),
                  Text('로그인', style: $style.text.subTitle20),
                  SizedBox(height: 12 * sizeUnit),
                  InkWell(
                    onTap: () async {
                      if(false == await GlobalFunction.globalLogin() && GlobalData.loginUser != null){ //로그인 성공시
                        Get.offAllNamed(Routes.home);
                      }else{ //로그인 실패시
                        GlobalFunction.showToast(msg: '로그인 실패');
                      }
                    },
                    child: Container(
                      width: 240 * sizeUnit,
                      height: 36 * sizeUnit,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6 * sizeUnit),
                          border: Border.all(color: $style.colors.barrierColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(GlobalAssets.svgGoogleLogo, width: 24 * sizeUnit, height: 18 * sizeUnit,),
                          SizedBox(width: 24 * sizeUnit),
                          Text('구글 계정으로 계속하기', style: $style.text.subTitle14,)
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
                            child: Divider(height: 0.1 * sizeUnit,)
                        ),
                        SizedBox(width: 10 * sizeUnit,),
                        Text('또는', style: $style.text.subTitle14.copyWith(color: $style.colors.grey),),
                        SizedBox(width: 10 * sizeUnit,),
                        SizedBox(
                            width: 100 * sizeUnit,
                            child: Divider(height: 0.1 * sizeUnit,)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18 * sizeUnit),
                  InkWell(
                    onTap: () async {
                      if(kDebugMode){
                        Get.delete<HomePageController>();

                        Get.toNamed(Routes.home);
                      }else{
                        Get.toNamed(Routes.index);
                      }
                    },
                    child: Container(
                      width: 240 * sizeUnit,
                      height: 36 * sizeUnit,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6 * sizeUnit),
                          border: Border.all(color: $style.colors.barrierColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('로그인 없이 무료로 계속하기', style: $style.text.subTitle14,)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            )
          );
        },
      ),
    );
  }
}
