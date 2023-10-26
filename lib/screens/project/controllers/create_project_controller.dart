import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';

import '../../../util/global_function.dart';

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

  Project project = Project.nullProject.copyWith(); // 생성되는 프로젝트
  int currentPage = 0; // 현재 페이지
  Color seedColor = $style.colors.primary; // 시드 컬러
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: seedColor); // 시드 호환 컬러
  late Rx<XFile> mainImgXFile = XFile(project.imgPath).obs; // 헤더 이미지
  RxBool descriptionsIsOk = false.obs; // description isOk

  String callbackType = ''; // 콜백 타입
  List<String> detailCallbackTypeList = []; // 디테일 콜백 타입 리스트

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

  // 사진 가져오기
  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? xFile;

    xFile = await picker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      if (await GlobalFunction.isBigFile(xFile)) {
        GlobalFunction.showToast(msg: '사진의 크기는 15mb를 넘을 수 없습니다.');
      } else {
        return xFile;
      }
    }

    return null;
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
  void descriptionsIsOkCheck(){
    for(Description description in project.descriptions) {
      if(description.title.isEmpty || description.contents.isEmpty || description.imgPath.isEmpty) {
        descriptionsIsOk(false);
        return;
      }
    }

    descriptionsIsOk(true);
  }

  // 콜투 액션 타입 세팅
  void setCallbackType(String type){
    callbackType = type;
    detailCallbackTypeList.clear();

    update(['callToAction']);
  }

  // 콜투 액션 디테일 타입 세팅
  void setDetailCallbackType(String type, bool isContain) {
    if(detailCallbackTypeList.isEmpty) {
      detailCallbackTypeList.add(type);
    } else {
      if(isContain) {
        detailCallbackTypeList.remove(type);
      } else {
        if(type.isNotEmpty) detailCallbackTypeList.add(type);
      }
    }

    // print(detailCallbackTypeList);
    update(['callToAction']);
  }

  // call to action isOk
  bool callToActionIsOk(){
    if(callbackType.isEmpty) return false;

    switch(callbackType) {
      case UserCallback.typeNone:
        return detailCallbackTypeList.isEmpty;
      case UserCallback.typeForm:
        return detailCallbackTypeList.isNotEmpty;
      case UserCallback.typeLink:
        return detailCallbackTypeList.isNotEmpty;
      default:
        return false;
    }
  }
}
