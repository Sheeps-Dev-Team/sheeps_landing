import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/screens/info/privacy%20_policy_page.dart';
import 'package:sheeps_landing/screens/info/terms_of_service_page.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/controllers/default_template_controller.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/sheeps_ani.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../util/components/get_cached_network_image.dart';

// ignore: must_be_immutable
class DefaultTemplate extends StatelessWidget {
  DefaultTemplate({super.key, required this.project});

  final Project project;

  static const int id = 1;

  final DefaultTemplateController controller = Get.put(DefaultTemplateController(), tag: Get.parameters['id']);
  final ProjectController projectController = Get.find<ProjectController>(tag: Get.parameters['id']);

  late final Color keyColor = Color(project.keyColor);
  late final ColorScheme colorScheme = GlobalFunction.getColorScheme(keyColor);
  late TextStyle titleStyle = $style.text.headline32.copyWith(fontSize: 40 * sizeUnit, color: colorScheme.onPrimaryContainer);
  late TextStyle contentsStyle = $style.text.body16.copyWith(height: 1.6, color: colorScheme.onPrimaryContainer);
  late final Color sectionColor = colorScheme.primaryContainer.withOpacity(.2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double currentWidth = constraints.maxWidth;
      final bool isDesktop = currentWidth >= 1100;

      if (isDesktop) {
        titleStyle = $style.text.headline32.copyWith(fontSize: 40 * sizeUnit, color: colorScheme.onPrimaryContainer);
        contentsStyle = $style.text.body16.copyWith(height: 1.6, color: colorScheme.onPrimaryContainer);
      } else {
        titleStyle = titleStyle.copyWith(fontSize: 32 * sizeUnit);
        contentsStyle = contentsStyle.copyWith(fontSize: 15 * sizeUnit);
      }

      return GetBuilder<DefaultTemplateController>(
        tag: Get.parameters['id'],
        initState: (state) => controller.initState(project),
        builder: (_) {
          return Scaffold(
            body: ScrollablePositionedList.builder(
              itemScrollController: controller.itemScrollController,
              itemPositionsListener: controller.itemPositionsListener,
              itemCount: 6,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Responsive(
                      desktop: header(currentWidth),
                      mobile: mobileHeader(),
                    );
                  case 1:
                    return Responsive(
                      desktop: description(
                        project.descriptions[0],
                        isOdd: false,
                        isActive: controller.description01Ani,
                        currentWidth: currentWidth,
                      ),
                      mobile: mobileDescription(
                        project.descriptions[0],
                        isOdd: false,
                        isActive: controller.description01Ani,
                      ),
                    );
                  case 2:
                    return project.descriptions.length > 1
                        ? Responsive(
                            desktop: description(
                              project.descriptions[1],
                              isOdd: true,
                              isActive: controller.description02Ani,
                              currentWidth: currentWidth,
                            ),
                            mobile: mobileDescription(
                              project.descriptions[1],
                              isOdd: true,
                              isActive: controller.description02Ani,
                            ),
                          )
                        : const SizedBox.shrink();
                  case 3:
                    return project.descriptions.length > 2
                        ? Responsive(
                            desktop: description(
                              project.descriptions[2],
                              isOdd: false,
                              isActive: controller.description03Ani,
                              currentWidth: currentWidth,
                            ),
                            mobile: mobileDescription(
                              project.descriptions[2],
                              isOdd: false,
                              isActive: controller.description03Ani,
                            ),
                          )
                        : const SizedBox.shrink();
                  case 4:
                    return callToAction();
                  case 5:
                    if (projectController.isIndex) {
                      if (isDesktop) {
                        return footerDesktop();
                      } else {
                        return footerMobile();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      );
    });
  }

  SingleChildScrollView footerMobile() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: $style.insets.$20),
        child: Column(
          children: [
            SizedBox(
              width: 224,
              child: Column(
                children: [
                  Text(
                    'SNS',
                    style: $style.text.headline20,
                  ),
                  Gap($style.insets.$8),
                  footerTextWidget(
                    text: 'Instagram',
                    onTap: () => GlobalFunction.launch(Uri.parse('https://www.instagram.com/sheeps_up/')),
                  ),
                  footerTextWidget(
                    text: 'sheeps.kr',
                    onTap: () => GlobalFunction.launch(Uri.parse('https://www.sheeps.kr/')),
                  ),
                ],
              ),
            ),
            Gap($style.insets.$24),
            SizedBox(
              width: 224,
              child: Column(
                children: [
                  Text(
                    'CONTACT',
                    style: $style.text.headline20,
                  ),
                  Gap($style.insets.$8),
                  footerTextWidget(
                    text: 'teddy@noteasy.kr',
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: 'teddy@noteasy.kr'));
                      GlobalFunction.showToast(msg: '클립보드에 복사되었습니다.');
                    },
                  ),
                ],
              ),
            ),
            Gap($style.insets.$20),
            SizedBox(
              width: 224,
              child: Column(
                children: [
                  Text(
                    'INFO',
                    style: $style.text.headline20,
                  ),
                  Gap($style.insets.$8),
                  footerTextWidget(
                      text: '서비스 이용약관',
                      onTap: () {
                        Get.to(() => const TermsOfServicePage());
                      }),
                  Gap($style.insets.$4),
                  footerTextWidget(
                      text: '개인정보 처리방침',
                      onTap: () {
                        Get.to(() => const PrivacyPolicyPage());
                      }),
                  Gap($style.insets.$20),
                ],
              ),
            ),
            Text(
              'Ⓒ 2023 Sheeps Inc. 모든 권리 보유.',
              style: $style.text.body14.copyWith(color: $style.colors.grey),
            ),
            //Gap($style.insets.$20),
          ],
        ),
      ),
    );
  }

//푸터
  Container footerDesktop() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: $style.insets.$30,
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap($style.insets.$16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 256,
                height: 80,
                child: Column(
                  children: [
                    Text(
                      'SNS',
                      style: $style.text.headline20,
                    ),
                    Gap($style.insets.$8),
                    footerTextWidget(
                      text: 'Instagram',
                      onTap: () => GlobalFunction.launch(Uri.parse('https://www.instagram.com/sheeps_up/')),
                    ),
                    footerTextWidget(
                      text: 'sheeps.kr',
                      onTap: () => GlobalFunction.launch(Uri.parse('https://www.sheeps.kr/')),
                    ),
                  ],
                ),
              ),
              const Gap(118),
              SizedBox(
                width: 256,
                height: 80,
                child: Column(
                  children: [
                    Text(
                      'CONTACT',
                      style: $style.text.headline20,
                    ),
                    Gap($style.insets.$16),
                    footerTextWidget(
                      text: 'teddy@noteasy.kr',
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: 'teddy@noteasy.kr'));
                        GlobalFunction.showToast(msg: '클립보드에 복사되었습니다.');
                      },
                    ),
                  ],
                ),
              ),
              const Gap(118),
              SizedBox(
                width: 256,
                height: 80,
                child: Column(
                  children: [
                    Text(
                      'INFO',
                      style: $style.text.headline20,
                    ),
                    Gap($style.insets.$8),
                    footerTextWidget(
                        text: '서비스 이용약관',
                        onTap: () {
                          Get.to(() => const TermsOfServicePage());
                        }),
                    Gap($style.insets.$4),
                    footerTextWidget(
                        text: '개인정보 처리방침',
                        onTap: () {
                          Get.to(() => const PrivacyPolicyPage());
                        }),
                  ],
                ),
              ),
            ],
          ),
          Gap($style.insets.$20),
          Center(
            child: Text(
              'Ⓒ 2023 Sheeps Inc. 모든 권리 보유.',
              style: $style.text.body14.copyWith(color: $style.colors.grey),
            ),
          ),
        ],
      ),
    );
  }

//푸터 텍스트버튼 위젯
  InkWell footerTextWidget({required String text, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: $style.text.body16.copyWith(decoration: TextDecoration.underline, decorationColor: $style.colors.darkGrey, color: $style.colors.darkGrey),
      ),
    );
  }

  Container callToAction() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: Get.height * .48),
      padding: EdgeInsets.symmetric(vertical: $style.insets.$160),
      color: project.descriptions.length.isOdd ? sectionColor : Colors.white,
      alignment: Alignment.center,
      child: SheepsAniFadeIn(
        isAction: controller.callToActionAni,
        direction: Direction.up,
        distance: controller.distance,
        child: Column(
          children: [
            Text(
              project.title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            Gap($style.insets.$40),
            actionButton(),
          ],
        ),
      ),
    );
  }

  // 헤더
  Widget header(double currentWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: $style.insets.$48,
        horizontal: calSizeUnit(currentWidth, $style.insets.$160),
      ),
      width: double.infinity,
      color: sectionColor,
      child: SheepsAniFadeIn(
        isAction: controller.headerAni,
        direction: Direction.up,
        distance: controller.distance,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular($style.corners.$24),
              child: GetCachedNetworkImage(
                imageUrl: project.imgPath,
                height: 300 * sizeUnit,
                width: 680 * sizeUnit,
                fit: BoxFit.contain,
                progressColor: Color(project.keyColor),
              ),
            ),
            Gap($style.insets.$40),
            Text(
              project.title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            Gap($style.insets.$40),
            Text(
              project.contents,
              style: contentsStyle,
              textAlign: TextAlign.center,
            ),
            Gap($style.insets.$40),
            actionButton(customButtonStyle: CustomButtonStyle.outline48),
          ],
        ),
      ),
    );
  }

  // 모바일 헤더
  Widget mobileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: $style.insets.$40,
        horizontal: $style.insets.$16,
      ),
      width: double.infinity,
      color: sectionColor,
      child: SheepsAniFadeIn(
        isAction: controller.headerAni,
        direction: Direction.up,
        distance: controller.distance,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular($style.corners.$24),
              child: GetCachedNetworkImage(
                imageUrl: project.imgPath,
                height: 256 * sizeUnit,
                width: 360 * sizeUnit,
                fit: BoxFit.contain,
                progressColor: Color(project.keyColor),
              ),
            ),
            Gap($style.insets.$24),
            Text(
              project.title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            Gap($style.insets.$16),
            Text(
              project.contents,
              style: contentsStyle,
              textAlign: TextAlign.center,
            ),
            Gap($style.insets.$24),
            actionButton(customButtonStyle: CustomButtonStyle.outline48),
          ],
        ),
      ),
    );
  }

  Widget description(Description description, {required bool isOdd, required bool isActive, required double currentWidth}) {
    Widget titleAndContents() {
      return Expanded(
        child: Align(
          alignment: isOdd ? Alignment.centerLeft : Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description.title,
                style: titleStyle,
              ),
              Gap($style.insets.$20),
              Text(
                description.contents,
                style: contentsStyle,
              ),
            ],
          ),
        ),
      );
    }

    Widget img() {
      return Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular($style.corners.$24),
          child: GetCachedNetworkImage(
            imageUrl: description.imgPath,
            fit: BoxFit.contain,
            width: 632 * sizeUnit,
            height: 477 * sizeUnit,
            progressColor: Color(project.keyColor),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: $style.insets.$80,
        horizontal: calSizeUnit(currentWidth, $style.insets.$160),
      ),
      color: isOdd ? sectionColor : Colors.white,
      child: SheepsAniFadeIn(
        distance: controller.distance * 4,
        direction: isOdd ? Direction.left : Direction.right,
        isAction: isActive,
        child: Row(
          mainAxisAlignment: isOdd ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isOdd) ...[
              img(),
            ] else ...[
              titleAndContents(),
            ],
            Gap($style.insets.$64),
            if (isOdd) ...[
              titleAndContents(),
            ] else ...[
              img(),
            ],
          ],
        ),
      ),
    );
  }

  Widget mobileDescription(Description description, {required bool isOdd, required bool isActive}) {
    Widget titleAndContents() {
      return Column(
        children: [
          Text(
            description.title,
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          Gap($style.insets.$20),
          Text(
            description.contents,
            style: contentsStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget img() {
      return ClipRRect(
        borderRadius: BorderRadius.circular($style.corners.$24),
        child: GetCachedNetworkImage(
          imageUrl: description.imgPath,
          height: 357 * sizeUnit,
          width: 366 * sizeUnit,
          fit: BoxFit.contain,
          progressColor: Color(project.keyColor),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: $style.insets.$40,
        horizontal: $style.insets.$16,
      ),
      color: isOdd ? sectionColor : Colors.white,
      child: SheepsAniFadeIn(
        distance: controller.distance * 4,
        direction: isOdd ? Direction.left : Direction.right,
        isAction: isActive,
        child: Column(
          children: [
            titleAndContents(),
            Gap($style.insets.$24),
            img(),
          ],
        ),
      ),
    );
  }

  // 콜 투 액션 버튼
  Widget actionButton({CustomButtonStyle customButtonStyle = CustomButtonStyle.filled48}) {
    final List<String> typeList = project.callbackType.split(division);
    final String type = typeList.first;

    switch (type) {
      case UserCallback.typeNone:
        return const SizedBox.shrink();
      case UserCallback.typeForm:
        return CustomButton(
          customButtonStyle: customButtonStyle,
          borderRadius: BorderRadius.circular($style.corners.$24),
          color: keyColor,
          width: 122 * sizeUnit,
          text: '소식 받기',
          onTap: projectController.actionForForm,
        );
      case UserCallback.typeLink:
        return CustomButton(
          customButtonStyle: customButtonStyle,
          borderRadius: BorderRadius.circular($style.corners.$24),
          color: keyColor,
          width: 122 * sizeUnit,
          text: '자세히 보기',
          onTap: projectController.actionForLink,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
