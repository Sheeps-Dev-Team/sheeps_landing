import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/screens/project/controllers/create_project_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/custom_text_field.dart';
import 'package:sheeps_landing/util/components/get_extended_image.dart';
import 'package:sheeps_landing/util/components/preview.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/models/user_callback.dart';

class CreateProjectPage extends StatelessWidget {
  CreateProjectPage({super.key, this.isModify = false});

  final bool isModify;

  final CreateProjectController controller = Get.put(CreateProjectController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onWillPop: controller.onWillPop,
      child: GetBuilder<CreateProjectController>(
        initState: (state) => controller.initState(isModify),
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(),
            body: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: controller.pageController,
                  physics: kDebugMode ? null : const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  scrollDirection: Axis.vertical,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return questionForText(
                          value: controller.project.name.obs,
                          question: '프로젝트 이름을 입력해 주세요.',
                          hintText: '쉽스랜딩',
                          maxLength: 20,
                          onChanged: (value) => controller.project.name = value,
                        );
                      case 1:
                        return questionForText(
                          value: controller.project.title.obs,
                          question: '제목을 입력해 주세요.',
                          subQuestion: '제품이나 서비스를 한 문장으로 설명할 수 있다면 어떻게 설명하시겠어요?',
                          hintText: '아이디어 검증을 위한, 5분만에 만드는 랜딩 페이지',
                          maxLength: 40,
                          onChanged: (value) => controller.project.title = value,
                        );
                      case 2:
                        return questionForText(
                          value: controller.project.contents.obs,
                          question: '제품이나 서비스의 핵심 가치를 설명하는 문장',
                          subQuestion: '제품 또는 서비스의 핵심적인 가치에 대해 설명해 주세요.\n3~4줄 정도의 문장이 적당해요',
                          hintText:
                              '그동안 아이디어를 검증하는 과정이 너무 번거롭지 않았나요?\n\n단 5분만에 손쉽게 랜딩 페이지를 제작할 수 있는 툴을 통해, 자신만의 아이디어를 쉽게 검증해 보세요.\n\n디자인이나 코딩을 몰라도 걱정할 필요가 없습니다.\n\n몇 가지 질문에만 대답하면 멋진 랜딩 페이지가 완성됩니다.',
                          maxLine: 10,
                          maxLength: 200,
                          onChanged: (value) => controller.project.contents = value,
                        );
                      case 3:
                        return Obx(() => questionForImg(
                              question: '대표 이미지를 추가해 주세요.',
                              xFile: controller.mainImgXFile.value,
                              subQuestion: '제품이나 서비스를 시각적으로 나타내기에 가장 적합한 이미지는 무엇인가요?',
                              onGetImage: (xFile) {
                                if (xFile != null) {
                                  // 수정일 때 삭제되는 이미지 url 세팅
                                  if (isModify && controller.project.imgPath.contains(defaultImgUrl)) {
                                    controller.deleteMainImgUrl = controller.project.imgPath;
                                  }

                                  controller.mainImgXFile(xFile);
                                  controller.project.imgPath = xFile.path;
                                }
                              },
                              onCancel: () {
                                // 수정일 때 삭제되는 이미지 url 세팅
                                if (isModify && controller.project.imgPath.contains(defaultImgUrl)) {
                                  controller.deleteMainImgUrl = controller.project.imgPath;
                                }

                                controller.mainImgXFile(controller.nullXFile);
                                controller.project.imgPath = '';
                              },
                              onSubmit: controller.nextQuestion,
                            ));
                      case 4:
                        return descriptionQuestionWidget();
                      case 5:
                        return questionForCallToAction();
                      case 6:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text('키 컬러를 설정해 주세요.', style: $style.text.headline32),
                            Gap($style.insets.$24),
                            SizedBox(
                              width: 280 * sizeUnit,
                              child: Wrap(
                                spacing: 16 * sizeUnit,
                                runSpacing: 16 * sizeUnit,
                                children: List.generate(
                                  controller.keyColorList.length,
                                  (index) {
                                    final Color color = controller.keyColorList[index];
                                    final bool isKeyColor = controller.project.keyColor == color.value;

                                    return InkWell(
                                      onTap: () => controller.onChangedKeyColor(color),
                                      borderRadius: BorderRadius.circular(20 * sizeUnit),
                                      child: Container(
                                        width: 40 * sizeUnit,
                                        height: 40 * sizeUnit,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isKeyColor ? color : Colors.transparent,
                                          border: Border.all(width: 2 * sizeUnit, color: color),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomButton(
                              width: controller.nextButtonWidth,
                              customButtonStyle: CustomButtonStyle.outline48,
                              text: isModify ? '수정 페이지 확인' : '랜딩 페이지 확인',
                              color: controller.keyColor,
                              onTap: controller.goToProjectPage,
                            ),
                            Gap($style.insets.$40),
                          ],
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
                Positioned(
                  right: calSizeUnit(MediaQuery.of(context).size.width, 80),
                  child: GetBuilder<CreateProjectController>(
                    id: 'preview',
                    builder: (_) {
                      return Preview(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // 프로젝트 이름
                              PreviewItem(
                                isTwinkle: controller.currentPage == 0,
                                previewItemType: PreviewItemType.name,
                                color: controller.colorScheme.primaryContainer,
                                isShow: controller.project.name.isNotEmpty,
                              ),
                              Gap($style.insets.$12),
                              previewHeader(), // 헤더 프리뷰
                              Gap($style.insets.$16),
                              // descriptions 프리뷰
                              Column(
                                children: List.generate(controller.project.descriptions.length, (index) {
                                  final Description description = controller.project.descriptions[index];

                                  return previewDescription(
                                    description: description,
                                    isTwinkle: controller.currentPage == 4 && index == controller.project.descriptions.length - 1,
                                    isReverse: index.isOdd,
                                  );
                                }),
                              ),
                              previewCallToAction(), // 콜 투 액션 프리뷰
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 콜 투 액션 프리뷰
  Column previewCallToAction() {
    return Column(
      children: [
        // 제목
        PreviewItem(
          isTwinkle: controller.currentPage == 1,
          previewItemType: PreviewItemType.title,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.project.title.isNotEmpty,
        ),
        Gap($style.insets.$4),
        // 버튼
        PreviewItem(
          isTwinkle: controller.currentPage == 5,
          previewItemType: PreviewItemType.button,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.callToActionIsOk.value,
        ),
      ],
    );
  }

  // description 프리뷰
  Widget previewDescription({required Description description, required bool isTwinkle, bool isReverse = false}) {
    Column contents() {
      return Column(
        children: [
          // 제목
          PreviewItem(
            isTwinkle: isTwinkle,
            previewItemType: PreviewItemType.title,
            color: controller.colorScheme.primaryContainer,
            isShow: description.title.isNotEmpty,
          ),
          Gap($style.insets.$4),
          PreviewItem(
            isTwinkle: isTwinkle,
            previewItemType: PreviewItemType.text,
            color: controller.colorScheme.primaryContainer,
            isShow: description.contents.isNotEmpty,
          ),
          Gap($style.insets.$2),
          PreviewItem(
            isTwinkle: isTwinkle,
            previewItemType: PreviewItemType.text,
            color: controller.colorScheme.primaryContainer,
            isShow: description.contents.isNotEmpty,
          ),
        ],
      );
    }

    PreviewItem img() {
      return PreviewItem(
        isTwinkle: isTwinkle,
        previewItemType: PreviewItemType.subImg,
        color: controller.colorScheme.primaryContainer,
        isShow: description.imgPath.isNotEmpty,
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: isReverse ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isReverse) ...[
              img(),
            ] else ...[
              contents(),
            ],
            Gap($style.insets.$8),
            if (isReverse) ...[
              contents(),
            ] else ...[
              img(),
            ],
          ],
        ),
        Gap($style.insets.$12),
      ],
    );
  }

  // 헤더 프리뷰
  Widget previewHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 이미지
        PreviewItem(
          isTwinkle: controller.currentPage == 3,
          previewItemType: PreviewItemType.mainImg,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.project.imgPath.isNotEmpty,
        ),
        Gap($style.insets.$4),
        // 제목
        PreviewItem(
          isTwinkle: controller.currentPage == 1,
          previewItemType: PreviewItemType.title,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.project.title.isNotEmpty,
        ),
        Gap($style.insets.$4),
        PreviewItem(
          isTwinkle: controller.currentPage == 2,
          previewItemType: PreviewItemType.text,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.project.contents.isNotEmpty,
        ),
        Gap($style.insets.$2),
        PreviewItem(
          isTwinkle: controller.currentPage == 2,
          previewItemType: PreviewItemType.text,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.project.contents.isNotEmpty,
        ),
        Gap($style.insets.$4),
        // 버튼
        PreviewItem(
          isTwinkle: controller.currentPage == 5,
          previewItemType: PreviewItemType.button,
          color: controller.colorScheme.primaryContainer,
          isShow: controller.callToActionIsOk.value,
        ),
      ],
    );
  }

  // call to action 질문
  Widget questionForCallToAction() {
    Widget selectionBox({required String type, String? text}) {
      final bool isSelected = controller.callbackType == type;

      return InkWell(
        onTap: () {
          controller.setCallbackType(type);
          controller.callToActionOkCheck();
        },
        hoverColor: controller.colorScheme.primaryContainer.withOpacity(.15),
        splashColor: controller.colorScheme.primaryContainer.withOpacity(.3),
        highlightColor: controller.colorScheme.primaryContainer.withOpacity(.3),
        borderRadius: BorderRadius.circular($style.corners.$12),
        child: Container(
          width: 320 * sizeUnit,
          height: 120 * sizeUnit,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1 * sizeUnit,
              color: controller.colorScheme.secondary,
            ),
            color: isSelected ? controller.colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular($style.corners.$12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type,
                style: $style.text.headline20.copyWith(color: isSelected ? controller.colorScheme.onPrimaryContainer : null),
              ),
              if (text != null) ...[
                Gap($style.insets.$16),
                Text(
                  text,
                  style: $style.text.subTitle12.copyWith(color: isSelected ? controller.colorScheme.onPrimaryContainer : null),
                ),
              ],
            ],
          ),
        ),
      );
    }

    Widget callbackDetailWidget() {
      Widget detailSelectionBox({required String type}) {
        final bool isContain = controller.detailCallbackTypeList.contains(type);

        return InkWell(
          onTap: () {
            controller.setDetailCallbackType(type, isContain);
            controller.callToActionOkCheck();
          },
          hoverColor: controller.colorScheme.primaryContainer.withOpacity(.15),
          splashColor: controller.colorScheme.primaryContainer.withOpacity(.3),
          highlightColor: controller.colorScheme.primaryContainer.withOpacity(.3),
          borderRadius: BorderRadius.circular($style.corners.$12),
          child: Container(
            width: 160 * sizeUnit,
            height: 80 * sizeUnit,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1 * sizeUnit,
                color: controller.colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular($style.corners.$12),
              color: isContain ? controller.colorScheme.primaryContainer : null,
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: $style.text.subTitle14.copyWith(color: isContain ? controller.colorScheme.onPrimaryContainer : null),
            ),
          ),
        );
      }

      switch (controller.callbackType) {
        case UserCallback.typeNone:
          return const SizedBox.shrink();
        case UserCallback.typeForm:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              detailSelectionBox(type: UserCallback.formTypeName),
              Gap($style.insets.$12),
              detailSelectionBox(type: UserCallback.formTypeEmail),
              Gap($style.insets.$12),
              detailSelectionBox(type: UserCallback.formTypePhoneNumber),
            ],
          );
        case UserCallback.typeLink:
          final TextEditingController textEditingController = TextEditingController(text: controller.detailCallbackTypeList.isEmpty ? '' : controller.detailCallbackTypeList.first);
          RxString errorText = ''.obs;

          return Obx(() => CustomTextField(
                controller: textEditingController,
                width: controller.textFiledWidth,
                hintText: 'url을 입력해 주세요.',
                autofocus: true,
                focusBorderColor: controller.keyColor,
                cursorColor: controller.keyColor,
                errorText: errorText.isEmpty ? null : errorText.value,
                onChanged: (p0) async {
                  controller.detailCallbackTypeList.clear();

                  if (p0.isNotEmpty) {
                    if (await canLaunchUrlString(p0)) {
                      controller.detailCallbackTypeList.add(p0); // 디테일 콜백 세팅
                      errorText('');
                      controller.callToActionOkCheck();
                    } else {
                      errorText('유효한 url을 입력해 주세요.');
                      controller.callToActionOkCheck();
                    }
                  } else {
                    errorText('');
                    controller.callToActionOkCheck();
                  }
                },
              ));
        default:
          return const SizedBox.shrink();
      }
    }

    return Column(
      children: [
        Expanded(
          child: GetBuilder<CreateProjectController>(
              id: 'callToAction',
              builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    Text('Call To Action', style: $style.text.headline32),
                    Gap($style.insets.$12),
                    Text(
                      '사용자에게 받을 콜 투 액션 타입을 선택해 주세요.',
                      style: $style.text.subTitle18,
                      textAlign: TextAlign.center,
                    ),
                    Gap($style.insets.$40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectionBox(
                          type: UserCallback.typeNone,
                        ),
                        Gap($style.insets.$24),
                        selectionBox(
                          type: UserCallback.typeForm,
                          text: '이름, 전화번호, 이메일 등을 수집할 수 있습니다.',
                        ),
                        Gap($style.insets.$24),
                        selectionBox(
                          type: UserCallback.typeLink,
                          text: '원하는 url로 링크를 설정할 수 있습니다.',
                        ),
                      ],
                    ),
                    if (controller.callbackType.isNotEmpty) ...[
                      Gap($style.insets.$24),
                      callbackDetailWidget(),
                    ],
                  ],
                );
              }),
        ),
        Obx(() => CustomButton(
              width: controller.nextButtonWidth,
              customButtonStyle: CustomButtonStyle.outline48,
              text: '다음',
              isOk: controller.callToActionIsOk.value,
              color: controller.keyColor,
              onTap: controller.nextQuestion,
            )),
        Gap($style.insets.$40),
      ],
    );
  }

  Widget descriptionQuestionWidget() {
    // 핵심 기능 질문
    Column questionForDescription({
      required int index,
      required Description description,
      required String question,
      required String titleHintText,
      required String contentsHintText,
      bool isReverse = false,
    }) {
      // 이미지 박스
      Widget imgBox() {
        Rx<XFile> xFile = XFile(description.imgPath).obs;

        return Obx(() => imgSelectionBox(
              width: 612 * sizeUnit,
              height: 457 * sizeUnit,
              xFile: xFile.value,
              onCancel: () {
                if (isModify && description.imgPath.contains(defaultImgUrl)) {
                  controller.deleteDescriptionImgUrl.add(description.imgPath); // 삭제하는 이미지 url add
                } else {
                  controller.descriptionXFileList.removeAt(index);
                }

                description.imgPath = '';
                xFile(controller.nullXFile);
                controller.descriptionsIsOkCheck(); // ok 체크
              },
              onGetImage: (value) {
                if (value != null) {
                  if (isModify && description.imgPath.contains(defaultImgUrl)) {
                    controller.deleteDescriptionImgUrl.add(description.imgPath); // 삭제하는 이미지 url add
                  }

                  if (controller.descriptionXFileList.length - 1 >= index) {
                    controller.descriptionXFileList[index] = value;
                  } else {
                    controller.descriptionXFileList.add(value);
                  }

                  description.imgPath = value.path;
                  xFile(value);
                  controller.descriptionsIsOkCheck(); // ok 체크
                }
              },
            ));
      }

      // 텍스트 필드 컬럼
      Column textFieldColumn() {
        return Column(
          children: [
            CustomTextField(
              controller: TextEditingController(text: description.title),
              width: controller.textFiledWidth,
              hintText: titleHintText,
              autofocus: true,
              maxLength: 40,
              focusBorderColor: controller.keyColor,
              cursorColor: controller.keyColor,
              onChanged: (p0) {
                description.title = p0;
                controller.descriptionsIsOkCheck(); // ok 체크
              },
            ),
            Gap($style.insets.$16),
            CustomTextField(
              controller: TextEditingController(text: description.contents),
              width: controller.textFiledWidth,
              hintText: contentsHintText,
              autofocus: true,
              maxLines: 10,
              minLines: 10,
              maxLength: 200,
              focusBorderColor: controller.keyColor,
              cursorColor: controller.keyColor,
              onChanged: (p0) {
                description.contents = p0;
                controller.descriptionsIsOkCheck(); // ok 체크
              },
            ),
          ],
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: $style.text.headline32),
          Gap($style.insets.$12),
          Text(
            '제품이나 서비스의 핵심 기능에 대해 설명해 주세요.',
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isReverse ? imgBox() : textFieldColumn(),
              Gap($style.insets.$40),
              isReverse ? textFieldColumn() : imgBox(),
            ],
          ),
        ],
      );
    }

    // 핵심 기능 삭제 버튼
    InkWell removeButton(int index) {
      return InkWell(
        onTap: () => controller.removeDescription(index),
        child: SvgPicture.asset(
          GlobalAssets.svgCancel,
          width: 24 * sizeUnit,
          colorFilter: ColorFilter.mode(controller.keyColor, BlendMode.srcIn),
        ),
      );
    }

    // 핵심 기능 추가 버튼
    InkWell addButton() {
      return InkWell(
        onTap: controller.addDescription,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              GlobalAssets.svgPlusCircle,
              width: 24 * sizeUnit,
              colorFilter: ColorFilter.mode(controller.keyColor, BlendMode.srcIn),
            ),
            Gap($style.insets.$4),
            Text('핵심 기능 추가', style: $style.text.subTitle12.copyWith(color: controller.keyColor)),
          ],
        ),
      );
    }

    return GetBuilder<CreateProjectController>(
      id: 'descriptions',
      builder: (_) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    controller: controller.descriptionScrollController,
                    child: Column(
                      children: List.generate(controller.project.descriptions.length, (index) {
                        final Description description = controller.project.descriptions[index];

                        return SizedBox(
                          width: 1052 * sizeUnit,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  if (controller.project.descriptions.length > 1) Gap($style.insets.$40),
                                  questionForDescription(
                                    index: index,
                                    description: description,
                                    question: '핵심 기능 0${index + 1}',
                                    titleHintText: controller.descriptionTitleList[index],
                                    contentsHintText: controller.descriptionContentsList[index],
                                    isReverse: index.isOdd,
                                  ),
                                  Gap($style.insets.$24),
                                  if (index == controller.project.descriptions.length - 1) ...[
                                    if (controller.project.descriptions.length < descriptionMaxCount) ...[
                                      addButton(), // 핵심 기능 추가 버튼
                                    ] else ...[
                                      Text('핵심 기능 설명은 최대 $descriptionMaxCount까지 추가 가능합니다.', style: $style.text.subTitle12.copyWith(color: controller.keyColor)),
                                    ],
                                  ],
                                  Gap($style.insets.$40),
                                ],
                              ),
                              if (controller.project.descriptions.length > 1) ...[
                                Positioned(
                                  top: 40 * sizeUnit,
                                  right: 4 * sizeUnit,
                                  child: removeButton(index), // 핵심 기능 삭제 버튼
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: $style.insets.$40),
              alignment: Alignment.center,
              child: Obx(() => CustomButton(
                    width: controller.nextButtonWidth,
                    customButtonStyle: CustomButtonStyle.outline48,
                    color: controller.keyColor,
                    text: '다음',
                    isOk: controller.descriptionsIsOk.value,
                    onTap: controller.nextQuestion,
                  )),
            ),
          ],
        );
      },
    );
  }

  // 텍스트용 질문
  Widget questionForText({
    required RxString value,
    required String question,
    String? subQuestion,
    required String hintText,
    int? maxLine,
    int? maxLength,
    required Function(String value) onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(question, style: $style.text.headline32),
        if (subQuestion != null) ...[
          Gap($style.insets.$12),
          Text(
            subQuestion,
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$40),
        ] else ...[
          Gap($style.insets.$80),
        ],
        CustomTextField(
          controller: TextEditingController(text: value.value),
          width: controller.textFiledWidth,
          autofocus: true,
          hintText: hintText,
          focusBorderColor: controller.keyColor,
          cursorColor: controller.keyColor,
          maxLines: maxLine ?? 1,
          minLines: maxLine ?? 1,
          maxLength: maxLength,
          onChanged: (p0) {
            onChanged(p0);
            value(p0);
          },
          onSubmitted: maxLine == null
              ? (p0) {
                  if (value.isNotEmpty) controller.nextQuestion;
                }
              : null,
        ),
        const Spacer(),
        Obx(
          () => CustomButton(
            width: controller.nextButtonWidth,
            customButtonStyle: CustomButtonStyle.outline48,
            text: '다음',
            isOk: value.isNotEmpty,
            color: controller.keyColor,
            onTap: controller.nextQuestion,
          ),
        ),
        Gap($style.insets.$40),
      ],
    );
  }

  // 이미지용 질문
  Widget questionForImg({
    required String question,
    required XFile xFile,
    String? subQuestion,
    required Function(XFile? xFile) onGetImage,
    required GestureTapCallback onCancel,
    required GestureTapCallback onSubmit,
  }) {
    final bool isNullImg = xFile.path.isEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(question, style: $style.text.headline32),
        if (subQuestion != null) ...[
          Gap($style.insets.$12),
          Text(
            subQuestion,
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$40),
        ] else ...[
          Gap($style.insets.$80),
        ],
        imgSelectionBox(
          width: 564 * sizeUnit,
          height: 290 * sizeUnit,
          onGetImage: onGetImage,
          xFile: xFile,
          onCancel: onCancel,
        ),
        const Spacer(),
        CustomButton(
          width: controller.nextButtonWidth,
          customButtonStyle: CustomButtonStyle.outline48,
          text: '다음',
          isOk: !isNullImg,
          color: controller.keyColor,
          onTap: onSubmit,
        ),
        Gap($style.insets.$40),
      ],
    );
  }

  // 이미지 선택 박스
  InkWell imgSelectionBox({
    required double width,
    required double height,
    required XFile xFile,
    required GestureTapCallback onCancel,
    required Function(XFile? xFile) onGetImage,
  }) {
    final bool isNullImg = xFile.path.isEmpty;

    return InkWell(
      onTap: () async => onGetImage(await controller.getImage()),
      borderRadius: BorderRadius.circular($style.corners.$12),
      hoverColor: controller.colorScheme.primaryContainer.withOpacity(.05),
      splashColor: controller.colorScheme.primaryContainer.withOpacity(.1),
      highlightColor: controller.colorScheme.primaryContainer.withOpacity(.1),
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: controller.colorScheme.primaryContainer.withOpacity(.1),
              borderRadius: BorderRadius.circular($style.corners.$12),
            ),
            alignment: Alignment.center,
            child: isNullImg
                ? SvgPicture.asset(
                    GlobalAssets.svgImg,
                    width: 96 * sizeUnit,
                    colorFilter: ColorFilter.mode(controller.colorScheme.primaryContainer, BlendMode.srcIn),
                  )
                : GetExtendedImage(
                    url: xFile.path,
                    fit: BoxFit.contain,
                  ),
          ),
          if (!isNullImg) ...[
            Positioned(
              top: 8 * sizeUnit,
              right: 8 * sizeUnit,
              child: InkWell(
                onTap: onCancel,
                child: SvgPicture.asset(
                  GlobalAssets.svgCancel,
                  width: 24 * sizeUnit,
                  colorFilter: ColorFilter.mode(controller.keyColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      leading: SizedBox(
        width: 24 * sizeUnit,
        height: 24 * sizeUnit,
        child: Center(
          child: InkWell(
            onTap: controller.previousQuestion,
            child: SvgPicture.asset(
              GlobalAssets.svgArrowLeft,
              width: 24 * sizeUnit,
              colorFilter: ColorFilter.mode($style.colors.black, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      surfaceTintColor: controller.keyColor,
    );
  }
}
