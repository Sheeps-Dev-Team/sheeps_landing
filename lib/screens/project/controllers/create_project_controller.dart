import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/util/global_function.dart';

class CreateProjectController extends GetxController {
  final PageController pageController = PageController();
  final ScrollController descriptionScrollController = ScrollController();
  final nullXFile = XFile('');
  final double textFiledWidth = 400 * sizeUnit;
  final double nextButtonWidth = 320 * sizeUnit;
  final List<String> descriptionTitleList = ['번뜩이는 아이디어가 있으신가요?💡', '내 아이디어의 온도는?🌡️', '쉬운 검증, 빠른 도전🏎️'];
  final List<String> descriptionContentsList = [
    '연구 끝에 만들어진 몇 가지 핵심 질문에 답변하는 것만으로도\n매력적인 랜딩 페이지가 완성됩니다.',
    '방문자 트래킹을 통해 데이터를 수집하고\n다른 랜딩 페이지와 비교해\n아이디어의 잠재적 가치를 확인할 수 있습니다.️',
    '시작을 쉽게하도록 돕고 있습니다.\n아이디어를 빠르게 검증하고 성공적인 창업의 첫걸음을 시작하세요.',
  ];
  final List<Color> keyColorList = [
    const Color.fromRGBO(82, 58, 133, 1),
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    $style.colors.primary,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.black,
  ];

  Project project = Project.nullProject.copyWith(); // 생성되는 프로젝트
  int currentPage = 0; // 현재 페이지

  Color seedColor = $style.colors.primary; // 시드 컬러
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: seedColor); // 시드 호환 컬러

  late Rx<XFile> mainImgXFile = XFile(project.imgPath).obs; // 헤더 이미지

  RxBool descriptionsIsOk = false.obs; // description isOk
  List<XFile> descriptionXFileList = []; // description 이미지 리스트

  String callbackType = ''; // 콜백 타입
  List<String> detailCallbackTypeList = []; // 디테일 콜백 타입 리스트
  RxBool callToActionIsOk = false.obs; // callToAction isOk

  @override
  void onClose() {
    super.onClose();

    pageController.dispose();
    descriptionScrollController.dispose();
  }

  // 다음 질문
  void nextQuestion() {
    pageController.nextPage(duration: $style.times.ms300, curve: Curves.easeIn);
  }

  // 이전 질문
  void previousQuestion() {
    if (currentPage > 0) {
      pageController.previousPage(duration: $style.times.ms300, curve: Curves.easeIn);
    } else {
      onWillPop();
    }
  }

  Future<bool> onWillPop() async {
    late bool value;
    await GlobalFunction.showCustomDialog(
        title: '정말 종료하시겠어요?',
        description: '작성하던 내용들이 모두 사라져요.',
        showCancelBtn: true,
        okText: '계속 만들기',
        okFunc: () {
          value = false;
          Get.close(1); // 다이얼로그
        },
        cancelText: '종료',
        cancelFunc: () {
          value = true;
          if (Get.previousRoute == Routes.home) {
            Get.close(2); // 다이얼로그, 현재 페이지
          } else {
            Get.offAllNamed(Routes.home);
          }
        });

    return value;
  }

  // 사진 가져오기
  Future<XFile?> getImage() async {
    XFile? selectedImage;

    FilePickerResult? pickedFileWeb = await FilePicker.platform.pickFiles(type: FileType.image);

    if (pickedFileWeb != null) {
      Uint8List? fileBytes = pickedFileWeb.files.first.bytes;

      selectedImage = XFile.fromData(fileBytes!, name: pickedFileWeb.files.first.name);
    }

    return selectedImage;
  }

  // 페이지 변경
  void onPageChanged(int index) {
    currentPage = index;
    update(['preview']);
  }

  // description 추가
  void addDescription() {
    project.descriptions.add(Description.nullDescription.copyWith());

    update(['descriptions']);
    update(['preview']);

    descriptionsIsOkCheck(); // ok 체크

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (descriptionScrollController.hasClients) {
        descriptionScrollController.animateTo(descriptionScrollController.position.pixels, duration: $style.times.ms150, curve: Curves.ease);
      }
    });
  }

  // description 삭제
  void removeDescription(int index) {
    project.descriptions.removeAt(index);
    update(['descriptions']);
    update(['preview']);

    descriptionsIsOkCheck(); // ok 체크
  }

  // descriptions isOk 체크
  void descriptionsIsOkCheck() {
    for (Description description in project.descriptions) {
      if (description.title.isEmpty || description.contents.isEmpty || description.imgPath.isEmpty) {
        descriptionsIsOk(false);
        return;
      }
    }

    descriptionsIsOk(true);
  }

  // 콜투 액션 타입 세팅
  void setCallbackType(String type) {
    callbackType = type;
    detailCallbackTypeList.clear();

    update(['callToAction']);
  }

  // 콜투 액션 디테일 타입 세팅
  void setDetailCallbackType(String type, bool isContain) {
    if (detailCallbackTypeList.isEmpty) {
      detailCallbackTypeList.add(type);
    } else {
      if (isContain) {
        detailCallbackTypeList.remove(type);
      } else {
        if (type.isNotEmpty) detailCallbackTypeList.add(type);
      }
    }

    update(['callToAction']);
  }

  // call to action isOk
  void callToActionOkCheck() {
    if (callbackType.isEmpty) callToActionIsOk(false);

    switch (callbackType) {
      case UserCallback.typeNone:
        callToActionIsOk(detailCallbackTypeList.isEmpty);
      case UserCallback.typeForm:
        callToActionIsOk(detailCallbackTypeList.isNotEmpty);
      case UserCallback.typeLink:
        callToActionIsOk(detailCallbackTypeList.isNotEmpty);
      default:
        callToActionIsOk(false);
    }
  }

  // callbackType 조립
  String assemblyCallbackType() {
    if (callbackType == UserCallback.typeNone) return callbackType;
    String detailType = '';

    for (int i = 0; i < detailCallbackTypeList.length; i++) {
      final String detail = detailCallbackTypeList[i];

      if (i < detailCallbackTypeList.length - 1) {
        detailType += '$detail$formDivision';
      } else {
        detailType += detail;
      }
    }

    return '$callbackType$division$detailType';
  }

  // 키 컬러 변경
  void onChangedKeyColor(Color color) {
    seedColor = color;
    project.keyColor = color.value;

    update();
  }

  // 프로젝트 생성
  Future<void> createProject() async {
    GlobalFunction.loadingDialog(); // 로딩 시작

    // 메인 이미지 등록
    final String? mainImageUrl = await imgUpload(mainImgXFile.value);

    List<String> descriptionImageUrlList = []; // description 이미지 url 리스트

    if (mainImageUrl != null) {
      // description 이미지 등록
      for (XFile xFile in descriptionXFileList) {
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
    project.callbackType = assemblyCallbackType(); // 콜백 타입 설정

    // 프로젝트 업로드
    Project? res = await ProjectRepository.createProject(project);

    if (res != null) {
      Get.close(1); // 로딩 끝
      // 결과물 페이지로 이동
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
}
