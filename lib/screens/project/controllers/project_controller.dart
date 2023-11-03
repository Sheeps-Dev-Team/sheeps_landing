import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/repository/user_repository.dart';
import 'package:sheeps_landing/screens/project/controllers/create_project_controller.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../../config/constants.dart';
import '../../../data/models/user_callback.dart';
import '../../../repository/user_callback_repository.dart';
import '../../../util/components/custom_button.dart';
import '../../../util/components/custom_text_field.dart';

class ProjectController extends GetxController {
  late final Project project;
  late final bool isIndex; // 쉽스 랜딩 페이지
  late bool isModify; // 수정 여부
  late bool isTmp; // 임시 여부

  late final Color keyColor;
  late final ColorScheme colorScheme;

  bool isLoading = true;
  RxBool isLike = false.obs; // 좋아요 여부
  bool isDesktopView = true; // 데스크탑 모드로 보기

  void initState({required bool isIndex}) async {
    this.isIndex = isIndex; // 쉽스 랜딩 페이지인지
    if (isIndex) {
      await loginCheck(); // 로그인 체크

      // 로그인이 된 경우 홈으로
      if (GlobalData.loginUser != null) {
        Get.offAllNamed(Routes.home);
        return;
      }
    }

    final Project? tmpProject = Get.arguments;

    // 수정 여부
    final String? isModify = Get.parameters['isModify'];
    this.isModify = isModify == null
        ? false
        : isModify == 'true'
            ? true
            : false;

    // 임시 여부
    final String? isTmp = Get.parameters['isTmp'];
    this.isTmp = isTmp == null
        ? false
        : isTmp == 'true'
            ? true
            : false;

    if (tmpProject == null) {
      late final String? id;

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
        project = res;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        isLike((prefs.getStringList(likedIdListKey) ?? []).contains(project.documentID));

        // 프로젝트 조회수 up
        if (kReleaseMode) ProjectRepository.updateViewCount(documentID: project.documentID);
      } else {
        return GlobalFunction.goToBack(); // 잘못된 project 예외처리
      }
    } else {
      project = tmpProject;
    }

    keyColor = Color(project.keyColor);
    colorScheme = ColorScheme.fromSeed(seedColor: keyColor);

    isLoading = false;
    update();
  }

  // 로그인 체크
  Future<void> loginCheck() async {
    // 로그인 안되어있는 경우
    if (GlobalData.loginUser == null) {
      const storage = FlutterSecureStorage();
      final String? email = await storage.read(key: 'email');

      // 자동 로그인 정보 있는 경우
      if (email != null) {
        final User? user = await UserRepository.getUserByEmail(email);

        // 로그인 성공
        if (user != null) GlobalData.loginUser = user;
      }
    }
  }

  // 프로젝트 생성
  Future<void> createProject() async {
    if (GlobalData.loginUser == null) {
      GlobalFunction.showCustomDialog(
        title: '로그인이 필요한 서비스입니다.',
        description: '프로젝트 생성 및 게시는\n로그인이 필요한 서비스입니다.',
        showCancelBtn: true,
        okText: '로그인',
        okFunc: () async {
          Get.close(1); // 다이얼로그 끄기

          GlobalFunction.loadingDialog(); // 로딩 시작
          await GlobalFunction.globalLogin(); // 로그인
          Get.close(1); // 로딩 끝
          GlobalFunction.showToast(msg: '로그인이 완료되었습니다.');
        },
      );

      return;
    }

    final CreateProjectController createProjectController = Get.find<CreateProjectController>();

    GlobalFunction.loadingDialog(color: keyColor); // 로딩 시작

    // 메인 이미지 등록
    final String? mainImageUrl = await imgUpload(createProjectController.mainImgXFile.value);

    List<String> descriptionImageUrlList = []; // description 이미지 url 리스트

    if (mainImageUrl != null) {
      // description 이미지 등록
      for (XFile xFile in createProjectController.descriptionXFileList) {
        final String? imageUrl = await imgUpload(xFile);

        if (imageUrl != null) {
          descriptionImageUrlList.add(imageUrl);
        } else {
          Get.close(1); // 로딩 끝

          // description 이미지 등록 실패 시 리턴
          return GlobalFunction.showToast(msg: '이미지 등록 실패');
        }
      }
    } else {
      Get.close(1); // 로딩 끝

      // 메인 이미지 등록 실패 시 리턴
      return GlobalFunction.showToast(msg: '이미지 등록 실패');
    }

    project.imgPath = mainImageUrl; // 메인 이미지 url 설정

    // description 이미지 url 설정
    for (int i = 0; i < descriptionImageUrlList.length; i++) {
      project.descriptions[i].imgPath = descriptionImageUrlList[i];
    }

    project.userDocumentID = GlobalData.loginUser!.documentID; // userID 설정

    // 프로젝트 생성
    Project? res = await ProjectRepository.createProject(project);

    if (res != null) {
      Get.close(3); // 로딩 끝, 임시 프로젝트 페이지, 프로젝트 생성 페이지
      Get.toNamed('${Routes.project}/${res.documentID}', arguments: res); // 프로젝트 페이지로 이동
    } else {
      Get.close(1); // 로딩 끝
      GlobalFunction.showToast(msg: '잠시후 다시 시도해 주세요.');
    }
  }

  // 프로젝트 수정
  void modifyProject() async {
    final CreateProjectController createProjectController = Get.find<CreateProjectController>();

    GlobalFunction.loadingDialog(color: keyColor); // 로딩 시작

    // 메인 이미지 바뀌었으면 등록
    if (createProjectController.deleteMainImgUrl != null) {
      String? mainImageUrl = await imgUpload(createProjectController.mainImgXFile.value);

      if (mainImageUrl != null) {
        await FirebaseStorage.instance.refFromURL(createProjectController.deleteMainImgUrl!).delete(); // 기존 이미지 삭제
        project.imgPath = mainImageUrl; // 메인 이미지 url 설정
      } else {
        Get.close(1); // 로딩 끝

        // 메인 이미지 등록 실패 시 리턴
        return GlobalFunction.showToast(msg: '이미지 등록 실패');
      }
    }

    // description 바뀐 이미지 등록
    for (XFile xFile in createProjectController.descriptionXFileList) {
      final String? imageUrl = await imgUpload(xFile);

      if (imageUrl != null) {
        final int idx = project.descriptions.indexWhere((element) => element.imgPath == xFile.path);
        final Description description = project.descriptions[idx];

        description.imgPath = imageUrl; // 이미지 url 세팅
      } else {
        Get.close(1); // 로딩 끝

        // description 이미지 등록 실패 시 리턴
        return GlobalFunction.showToast(msg: '이미지 등록 실패');
      }
    }

    // 기존 이미지 삭제
    for (String url in createProjectController.deleteDescriptionImgUrl) {
      await FirebaseStorage.instance.refFromURL(url).delete();
    }

    // 프로젝트 수정
    Project? res = await ProjectRepository.modifyProject(project);

    if (res != null) {
      Get.close(3); // 로딩 끝, 임시 프로젝트 페이지, 프로젝트 수정 페이지
      Get.toNamed('${Routes.project}/${res.documentID}', arguments: res); // 프로젝트 페이지로 이동
      // Get.until((route) => Get.currentRoute == '${Routes.projectManagement}/${project.documentID}');
    } else {
      Get.close(1); // 로딩 끝
      GlobalFunction.showToast(msg: '잠시후 다시 시도해 주세요.');
    }
  }

  // 이미지 업로드
  Future<String?> imgUpload(XFile xFile) async {
    String? url;

    try {
      Uint8List? fileBytes = await xFile.readAsBytes();
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.${xFile.name.split('.').last}';

      TaskSnapshot uploadTask = await FirebaseStorage.instance.ref('project/$fileName').putData(fileBytes);
      url = await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return url;
  }

  // 뷰 모드 변경
  void onChangedView() {
    isDesktopView = !isDesktopView;
    update();
  }

  // 좋아요 함수
  Future<bool> likeFunc() async {
    if (isLike.value) return true;

    // 임시 프로젝트인 경우
    if (isTmp) {
      isLike(true);
      return true;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> likedIdList = prefs.getStringList(likedIdListKey) ?? [];

    // 프로젝트 좋아요수 up
    final bool res = await ProjectRepository.updateLikeCount(documentID: project.documentID);

    if (res) {
      prefs.setStringList(likedIdListKey, [...likedIdList, project.documentID]);
      project.likeCount += 1;
    } else {
      GlobalFunction.showToast(msg: '잠시후 다시 시도해 주세요');
    }

    isLike(res);
    return res;
  }

  // 링크 액션
  void actionForLink() async {
    final String url = project.callbackType.split(division).last;
    GlobalFunction.launch(Uri.parse(url));

    if (isTmp) return; // 임시일 때 서버에 쏘지 않도록

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
    final List<String> typeList = project.callbackType.split(division).last.split(formDivision);

    String name = '';
    String email = '';
    String phoneNumber = '';

    bool isOk() {
      for (int i = 0; i < typeList.length; i++) {
        final String type = typeList[i];

        switch (type) {
          case UserCallback.formTypeName:
            if (GlobalFunction.validRealNameErrorText(name) != null) return false;
            break;
          case UserCallback.formTypeEmail:
            if (GlobalFunction.validEmailErrorText(email) != null) return false;
            break;
          case UserCallback.formTypePhoneNumber:
            if (GlobalFunction.validPhoneNumErrorText(phoneNumber) != null) return false;
            break;
        }
      }

      return true;
    }

    // 제출
    void submit() async {
      // 임시인 경우
      if (isTmp) {
        Get.close(1); // 다이얼로그 끄기
        return;
      }

      GlobalFunction.loadingDialog(color: keyColor);

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
      if (res != null) {
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
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                    customButtonStyle: CustomButtonStyle.filled48,
                    color: keyColor,
                    text: '확인',
                    isOk: isOk(),
                    onTap: submit,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
