import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/project/controllers/create_project_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/custom_text_field.dart';
import 'package:sheeps_landing/util/components/get_extended_image.dart';
import 'package:sheeps_landing/util/components/preview.dart';

class CreateProjectPage extends StatelessWidget {
  CreateProjectPage({super.key});

  final CreateProjectController controller = Get.put(CreateProjectController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          surfaceTintColor: controller.seedColor,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: controller.pageController,
              itemCount: 7,
              scrollDirection: Axis.vertical,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return questionForText(
                      question: '프로젝트 이름을 입력해 주세요.',
                      hintText: '쉽스랜딩',
                      maxLength: 20,
                      onSubmit: (answer) {
                        controller.nextQuestion();
                      },
                    );
                  case 1:
                    return questionForText(
                      question: '제목을 입력해 주세요.',
                      description: '제품이나 서비스를 한 문장으로 설명할 수 있다면 어떻게 설명하시겠어요?',
                      hintText: '아이디어 검증을 위한, 5분만에 만드는 랜딩 페이지',
                      maxLength: 40,
                      onSubmit: (answer) {
                        controller.nextQuestion();
                      },
                    );
                  case 2:
                    return questionForText(
                      question: '제품이나 서비스의 핵심 가치를 설명하는 문장',
                      description: '제품 또는 서비스의 핵심적인 가치에 대해 설명해 주세요.\n3~4줄 정도의 문장이 적당해요',
                      hintText:
                          '그동안 아이디어를 검증하는 과정이 너무 번거롭지 않았나요?\n\n단 5분만에 손쉽게 랜딩 페이지를 제작할 수 있는 툴을 통해, 자신만의 아이디어를 쉽게 검증해 보세요.\n\n디자인이나 코딩을 몰라도 걱정할 필요가 없습니다.\n\n몇 가지 질문에만 대답하면 멋진 랜딩 페이지가 완성됩니다.',
                      maxLine: 10,
                      maxLength: 200,
                      onSubmit: (answer) {
                        controller.nextQuestion();
                      },
                    );
                  case 3:
                    return Obx(() => questionForImg(
                          question: '대표 이미지를 추가해 주세요.',
                          xFile: controller.xFile01.value,
                          description: '제품이나 서비스를 시각적으로 나타내기에 가장 적합한 이미지는 무엇인가요?',
                          onGetImage: (xFile) {
                            if (xFile != null) controller.xFile01(xFile);
                          },
                          onCancel: () {
                            controller.xFile01(controller.nullXFile);
                          },
                          onSubmit: controller.nextQuestion,
                        ));
                }
                return Placeholder(child: Text(index.toString()));
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
                            ),
                            Gap($style.insets.$12),
                            Row(
                              children: [
                                // 이미지
                                PreviewItem(
                                  isTwinkle: controller.currentPage == 3,
                                  previewItemType: PreviewItemType.img01,
                                  color: controller.colorScheme.primaryContainer,
                                  isShow: controller.currentPage >= 3,
                                ),
                                Gap($style.insets.$8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 제목
                                    PreviewItem(
                                      isTwinkle: controller.currentPage == 1,
                                      previewItemType: PreviewItemType.title01,
                                      color: controller.colorScheme.primaryContainer,
                                      isShow: controller.currentPage >= 1,
                                    ),
                                    Gap($style.insets.$4),
                                    PreviewItem(
                                      isTwinkle: controller.currentPage == 2,
                                      previewItemType: PreviewItemType.text01,
                                      color: controller.colorScheme.primaryContainer,
                                      isShow: controller.currentPage >= 2,
                                    ),
                                    Gap($style.insets.$2),
                                    PreviewItem(
                                      isTwinkle: controller.currentPage == 2,
                                      previewItemType: PreviewItemType.text01,
                                      color: controller.colorScheme.primaryContainer,
                                      isShow: controller.currentPage >= 2,
                                    ),
                                    Gap($style.insets.$2),
                                    PreviewItem(
                                      isTwinkle: controller.currentPage == 2,
                                      previewItemType: PreviewItemType.text01,
                                      color: controller.colorScheme.primaryContainer,
                                      isShow: controller.currentPage >= 2,
                                    ),
                                    Gap($style.insets.$4),
                                    Row(
                                      children: [
                                        PreviewItem(
                                          isTwinkle: controller.currentPage == 5,
                                          previewItemType: PreviewItemType.button01,
                                          color: controller.colorScheme.primaryContainer,
                                          isShow: controller.currentPage >= 5,
                                        ),
                                        Gap($style.insets.$2),
                                        PreviewItem(
                                          isTwinkle: controller.currentPage == 5,
                                          previewItemType: PreviewItemType.button01,
                                          color: controller.colorScheme.primaryContainer,
                                          isShow: controller.currentPage >= 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
  
  // 텍스트용 질문
  Widget questionForText({
    required String question,
    String? description,
    required String hintText,
    int? maxLine,
    int? maxLength,
    required Function(String answer) onSubmit,
  }) {
    RxString value = ''.obs;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(question, style: $style.text.headline32),
        if (description != null) ...[
          Gap($style.insets.$12),
          Text(
            description,
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$40),
        ] else ...[
          Gap($style.insets.$80),
        ],
        CustomTextField(
          width: 400 * sizeUnit,
          autofocus: true,
          hintText: hintText,
          focusBorderColor: controller.seedColor,
          cursorColor: controller.seedColor,
          maxLines: maxLine ?? 1,
          minLines: maxLine ?? 1,
          maxLength: maxLength,
          onChanged: (p0) => value(p0),
          onSubmitted: maxLine == null
              ? (p0) {
                  if (value.isNotEmpty) onSubmit(value.value);
                }
              : null,
        ),
        const Spacer(),
        Obx(
          () => CustomButton(
            width: 320 * sizeUnit,
            customButtonStyle: CustomButtonStyle.outline48,
            text: '다음',
            isOk: value.isNotEmpty,
            color: controller.seedColor,
            onTap: () => onSubmit(value.value),
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
    String? description,
    required Function(XFile? xFile) onGetImage,
    required GestureTapCallback onCancel,
    required GestureTapCallback onSubmit,
  }) {
    final bool isNullImg = xFile == controller.nullXFile;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(question, style: $style.text.headline32),
        if (description != null) ...[
          Gap($style.insets.$12),
          Text(
            description,
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$40),
        ] else ...[
          Gap($style.insets.$80),
        ],
        InkWell(
          onTap: () async => onGetImage(await controller.getImage()),
          borderRadius: BorderRadius.circular($style.corners.$12),
          child: Stack(
            children: [
              Container(
                width: 564 * sizeUnit,
                height: 290 * sizeUnit,
                decoration: BoxDecoration(
                  color: controller.colorScheme.surface,
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
                        fit: BoxFit.cover,
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
                      colorFilter: ColorFilter.mode(controller.seedColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        CustomButton(
          width: 320 * sizeUnit,
          customButtonStyle: CustomButtonStyle.outline48,
          text: '다음',
          isOk: !isNullImg,
          color: controller.seedColor,
          onTap: onSubmit,
        ),
        Gap($style.insets.$40),
      ],
    );
  }
}
