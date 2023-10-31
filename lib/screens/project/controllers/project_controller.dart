import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../../config/constants.dart';
import '../../../data/models/user_callback.dart';
import '../../../repository/user_callback_repository.dart';
import '../../../util/components/custom_button.dart';
import '../../../util/components/custom_text_field.dart';

class ProjectController extends GetxController {
  late final Project project;
  late final bool isIndex;

  bool isLoading = true;
  RxBool isLike = false.obs;

  void initState({required Project? project, required bool isIndex}) async {
    if (project == null) {
      late final String? id;
      this.isIndex = isIndex;

      if (isIndex) {
        id = 'N1Z1RfyvMRfz52SP2K4g';
      } else {
        id = Get.parameters['id'];
      }

      // 잘못된 url 예외처리
      if (id == null) return GlobalFunction.goToBack();

      // 서버에서 프로젝트 불러오기
      Project? res = await ProjectRepository.getProjectByID(id);
      if (res != null) {
        this.project = res;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        isLike((prefs.getStringList(likedIdListKey) ?? []).contains(this.project.documentID));

        // 프로젝트 조회수 up
        if(kReleaseMode) {
          ProjectRepository.updateViewCount(documentID: this.project.documentID);
        }
      } else {
        return GlobalFunction.goToBack(); // 잘못된 project 예외처리
      }
    } else {
      this.project = project;
    }

    isLoading = false;
    update();
  }

  // 좋아요 함수
  Future<bool> likeFunc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> likedIdList = prefs.getStringList(likedIdListKey) ?? [];
    final bool isLike = likedIdList.contains(project.documentID);

    if (isLike) {
      this.isLike(true);
      return true;
    } else {
      // 프로젝트 좋아요수 up
      final bool res = await ProjectRepository.updateLikeCount(documentID: project.documentID);

      if (res){
        prefs.setStringList(likedIdListKey, [...likedIdList, project.documentID]);
        project.likeCount += 1;
      } else {
        GlobalFunction.showToast(msg: '잠시후 다시 시도해 주세요');
      }

      this.isLike(res);
      return res;
    }
  }

  // 링크 액션
  void actionForLink() async {
    // todo 임시일 때 서버에 쏘지 않기 - noah
    final String url = project.callbackType.split(division).last;
    GlobalFunction.launch(Uri.parse(url));

    final DateTime now = DateTime.now();
    final String ipAddress = await IpAddress().getIpAddress();

    UserCallbackRepository.createUserCallback(
      UserCallback(
        projectID: project.documentID,
        ip: ipAddress,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  // 폼 액션
  void actionForForm() async {
    // todo 임시일 때 서버에 쏘지 않기 - noah

    final List<String> typeList = project.callbackType.split(division).last.split(formDivision);
    final Color keyColor = Color(project.keyColor);

    String name = '';
    String email = '';
    String phoneNumber = '';

    bool isOk (){
      for(int i = 0; i < typeList.length; i++) {
        final String type = typeList[i];

        switch (type) {
          case UserCallback.formTypeName:
            if(GlobalFunction.validRealNameErrorText(name) != null) return false;
            break;
          case UserCallback.formTypeEmail:
            if(GlobalFunction.validEmailErrorText(email) != null) return false;
            break;
          case UserCallback.formTypePhoneNumber:
            if(GlobalFunction.validPhoneNumErrorText(phoneNumber) != null) return false;
            break;
        }
      }

      return true;
    }

    // 제출
    void submit() async{
      GlobalFunction.loadingDialog();

      final DateTime now = DateTime.now();
      final String ipAddress = await IpAddress().getIpAddress();

      final UserCallback? res = await UserCallbackRepository.createUserCallback(
        UserCallback(
          projectID: project.documentID,
          ip: ipAddress,
          name: name.isEmpty ? null : name,
          email: email.isEmpty ? null : email,
          phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
          createdAt: now,
          updatedAt: now,
        ),
      );

      Get.close(1); // 로딩 끄기
      if(res != null) {
        Get.close(1); // 다이얼로그 끄기
        GlobalFunction.showToast(msg: '제출되었습니다.');
      } else {
        GlobalFunction.showToast(msg: '잠시후 다시 시도해 주세요.');
      }
    }

    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: 300 * sizeUnit,
            padding: EdgeInsets.symmetric(horizontal: $style.insets.$16, vertical: $style.insets.$24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular($style.insets.$24),
            ),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('소식받기', style: $style.text.headline24),
                      Gap($style.insets.$24),
                      ...List.generate(typeList.length, (index) {
                        final String type = typeList[index];
                        late Widget child;

                        switch (type) {
                          case UserCallback.formTypeName:
                            child = CustomTextField(
                              label: Text(UserCallback.formTypeName, style: $style.text.subTitle14),
                              hintText: '이름을 입력해 주세요.',
                              focusBorderColor: keyColor,
                              cursorColor: keyColor,
                              errorText: name.isEmpty ? null : GlobalFunction.validRealNameErrorText(name),
                              onChanged: (p0) => setState(() => name = p0),
                            );
                            break;
                          case UserCallback.formTypeEmail:
                            child = CustomTextField(
                              label: Text(UserCallback.formTypeEmail, style: $style.text.subTitle14),
                              hintText: '이메일을 입력해 주세요.',
                              focusBorderColor: keyColor,
                              cursorColor: keyColor,
                              errorText: email.isEmpty ? null : GlobalFunction.validEmailErrorText(email),
                              onChanged: (p0) => setState(() => email = p0),
                            );
                            break;
                          case UserCallback.formTypePhoneNumber:
                            child = CustomTextField(
                              label: Text(UserCallback.formTypePhoneNumber, style: $style.text.subTitle14),
                              hintText: '전화번호를 입력해 주세요.',
                              focusBorderColor: keyColor,
                              cursorColor: keyColor,
                              errorText: phoneNumber.isEmpty ? null : GlobalFunction.validPhoneNumErrorText(phoneNumber),
                              onChanged: (p0) => setState(() => phoneNumber = p0),
                            );
                            break;
                          default:
                            child = const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            child,
                            Gap($style.insets.$16),
                          ],
                        );
                      }),
                      Gap($style.insets.$24),
                      CustomButton(
                        customButtonStyle: CustomButtonStyle.outline48,
                        color: keyColor,
                        text: '확인',
                        isOk: isOk(),
                        onTap: submit,
                      ),
                    ],
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
