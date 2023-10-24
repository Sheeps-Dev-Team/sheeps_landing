import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';

import '../../../util/global_function.dart';

class CreateProjectController extends GetxController {
  final PageController pageController = PageController();
  final nullXFile = XFile('');

  RxInt currentPage = 0.obs; // 현재 페이지
  Color seedColor = $style.colors.primary; // 시드 컬러
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: seedColor); // 시드 호환 컬러 모
  RxBool previewAnimation = false.obs; // 프리뷰 애니메이션 컨트롤용
  late Rx<XFile> xFile01 = nullXFile.obs; // 헤더 이미지

  @override
  void onInit() {
    super.onInit();

    debounce(
      previewAnimation,
      (_) => previewAnimation.toggle(),
      time: const Duration(seconds: 1),
    );

    previewAnimation(true);
  }

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
}
