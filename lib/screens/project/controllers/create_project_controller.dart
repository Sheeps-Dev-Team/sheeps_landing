import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';

import '../../../util/global_function.dart';
import 'package:dio/dio.dart' as DIO;

class CreateProjectController extends GetxController {
  final PageController pageController = PageController();
  final nullXFile = XFile('');

  int currentPage = 0; // 현재 페이지
  Color seedColor = $style.colors.primary; // 시드 컬러
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: seedColor); // 시드 호환 컬러 모
  late Rx<XFile> xFile01 = nullXFile.obs; // 헤더 이미지
  dynamic contentsImg;

  void nextQuestion() {
    pageController.nextPage(duration: $style.times.ms300, curve: Curves.easeIn);
  }

  // 사진 가져오기
  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? selectedImage;

    selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {

      contentsImg = selectedImage;

      final String fileName = selectedImage.path.split('/').last;

      // var file = DIO.MultipartFile.fromBytes(
      //   await selectedImage.readAsBytes(),
      //   filename: '$fileName.${selectedImage.mimeType == null ? 'jpeg' : selectedImage.mimeType!.split('/').last}',
      // );

      update(['img']);
    }

    return selectedImage;
  }

  // 페이지 변
  void onPageChanged(int index){
    currentPage = index;
    update(['preview']);
  }
}
