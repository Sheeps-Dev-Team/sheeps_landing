import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
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

  late final bool isModify; // 수정 여부

  Project project = Project.nullProject.copyWith(); // 생성되는 프로젝트
  int currentPage = 0; // 현재 페이지

  Color keyColor = $style.colors.primary; // 키 컬러
  ColorScheme get colorScheme => GlobalFunction.getColorScheme(keyColor); // 키 컬러 호환 컬러

  late Rx<XFile> mainImgXFile = XFile(project.imgPath).obs; // 헤더 이미지

  RxBool descriptionsIsOk = false.obs; // description isOk
  List<XFile> descriptionXFileList = []; // description 이미지 리스트

  String callbackType = ''; // 콜백 타입
  List<String> detailCallbackTypeList = []; // 디테일 콜백 타입 리스트
  RxBool callToActionIsOk = false.obs; // callToAction isOk

  String? deleteMainImgUrl; // 삭제하는 main 이미지 url (수정일 때만 씀)
  List<String> deleteDescriptionImgUrl = []; // 삭제하는 description 이미지 url (수정일 때만 씀)

  @override
  void onClose() {
    super.onClose();

    pageController.dispose();
    descriptionScrollController.dispose();
  }

  void initState(bool isModify) {
    this.isModify = isModify;

    // 수정 데이터 세팅
    if (isModify) {
      try {
        project = Get.arguments;
        keyColor = Color(project.keyColor);

        // 콜백 타입 세팅
        final List<String> typeList = project.callbackType.split(division);
        callbackType = typeList.first;
        detailCallbackTypeList = callbackType == UserCallback.typeNone ? [] : typeList.last.split(formDivision);

        descriptionsIsOk(true); // description ok 세팅
        callToActionIsOk(true); // callToAction ok 세팅
      } catch (e) {
        if (kDebugMode) print(e);
        GlobalFunction.goToBack();
      }
    }
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
          Get.close(2); // 다이얼로그
          value = true;
          Get.delete<CreateProjectController>();
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
    // 수정인 경우 기존 이미지 삭제
    final String imgUrl = project.descriptions[index].imgPath;
    if(isModify && imgUrl.contains(defaultImgUrl)) deleteDescriptionImgUrl.add(imgUrl);

    project.descriptions.removeAt(index);
    update(['descriptions']);
    update(['preview']);

    descriptionsIsOkCheck(); // ok 체크
  }

  // descriptions isOk 체크
  void descriptionsIsOkCheck() {
    for (Description description in project.descriptions){
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
    keyColor = color;
    project.keyColor = color.value;

    update();
  }

  // 프로젝트 페이지로 이동
  Future<void> goToProjectPage() async {
    project.callbackType = assemblyCallbackType(); // 콜백 타입 설정
    Get.toNamed(
      '${Routes.project}/${DateTime.now().millisecondsSinceEpoch}',
      arguments: project,
      parameters: {'isTmp': 'true', 'isModify': '$isModify'}
    );
  }
}
