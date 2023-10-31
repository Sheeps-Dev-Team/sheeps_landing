import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/controllers/default_template_controller.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/get_extended_image.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/sheeps_ani.dart';

// ignore: must_be_immutable
class DefaultTemplate extends StatelessWidget {
  DefaultTemplate({super.key, required this.project, required this.isIndex});

  final Project project;
  final bool isIndex;

  static const int id = 1;

  final DefaultTemplateController controller = Get.put(DefaultTemplateController());
  final ProjectController projectController = Get.find<ProjectController>();

  late final Color keyColor = Color(project.keyColor);
  late final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: keyColor);
  late TextStyle titleStyle = $style.text.headline32.copyWith(fontSize: 40 * sizeUnit, color: colorScheme.onSurface);
  late TextStyle contentsStyle = $style.text.body16.copyWith(height: 1.6, color: colorScheme.onSurface);
  late final Color sectionColor = colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final double currentWidth = MediaQuery.of(context).size.width;

    if (!isDesktop) {
      titleStyle = titleStyle.copyWith(fontSize: 32 * sizeUnit);
      contentsStyle = contentsStyle.copyWith(fontSize: 15 * sizeUnit);
    }

    return GetBuilder<DefaultTemplateController>(
      initState: (state) => controller.initState(project),
      builder: (_) {
        return Scaffold(
          appBar: appBar(isDesktop),
          body: ScrollablePositionedList.builder(
            itemScrollController: controller.itemScrollController,
            itemPositionsListener: controller.itemPositionsListener,
            itemCount: 5,
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
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Container callToAction() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: $style.insets.$160),
      color: project.descriptions.length.isOdd ? sectionColor : Colors.white,
      child: SheepsAniFadeIn(
        isAction: controller.callToActionAni,
        direction: Direction.up,
        distance: controller.distance,
        child: Column(
          children: [
            Text(project.title, style: titleStyle),
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
              child: GetExtendedImage(
                url: project.imgPath,
                fit: BoxFit.contain,
                width: 564 * sizeUnit,
                height: 290 * sizeUnit,
                loadingWidget: const SizedBox.shrink(),
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
              child: GetExtendedImage(
                url: project.imgPath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 256 * sizeUnit,
                loadingWidget: const SizedBox.shrink(),
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
          child: GetExtendedImage(
            url: description.imgPath,
            fit: BoxFit.contain,
            width: 632 * sizeUnit,
            height: 477 * sizeUnit,
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
        child: GetExtendedImage(
          url: description.imgPath,
          fit: BoxFit.contain,
          height: 357 * sizeUnit,
          width: 366 * sizeUnit,
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
          // mainAxisAlignment: isOdd ? MainAxisAlignment.start : MainAxisAlignment.end,
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

  CustomAppBar appBar(bool isDesktop) {
    return CustomAppBar(
      leading: const SizedBox.shrink(),
      height: isDesktop ? 72 * sizeUnit : null,
      actions: isIndex
          ? [
        InkWell(
          onTap: () => Get.toNamed(Routes.login),
          child: Text(
            '로그인',
            style: $style.text.subTitle16.copyWith(color: colorScheme.onSurface),
          ),
        ),
        Gap($style.insets.$16),
      ]
          : null,
      title: project.name,
      surfaceTintColor: keyColor,
    );
  }
}
