import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/screens/template/controllers/default_template_controller.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/get_extended_image.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/sheeps_ani.dart';
import 'package:sheeps_landing/util/global_function.dart';

class DefaultTemplate extends StatelessWidget {
  DefaultTemplate({super.key, required this.project});

  final Project project;

  static const int id = 1;

  final DefaultTemplateController controller = Get.put(DefaultTemplateController());

  late final Color keyColor = Color(project.keyColor);
  late final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: keyColor);
  late final TextStyle titleStyle = $style.text.headline32.copyWith(fontSize: 40 * sizeUnit, color: colorScheme.onSurface);
  late final TextStyle contentsStyle = $style.text.body16.copyWith(height: 1.6, color: colorScheme.onSurface);
  late final Color sectionColor = colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final double currentWidth = MediaQuery.of(context).size.width;

    return GetBuilder<DefaultTemplateController>(
      initState: (state) => controller.initState(project),
      builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            leading: const SizedBox.shrink(),
            height: 72 * sizeUnit,
            title: project.name,
            surfaceTintColor: keyColor,
          ),
          body: ScrollablePositionedList.builder(
            itemScrollController: controller.itemScrollController,
            itemPositionsListener: controller.itemPositionsListener,
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return header(currentWidth);
                case 1:
                  return description(
                    project.descriptions[0],
                    isOdd: false,
                    isActive: controller.description01Ani,
                    currentWidth: currentWidth,
                  );
                case 2:
                  return project.descriptions.length > 1
                      ? description(
                          project.descriptions[1],
                          isOdd: true,
                          isActive: controller.description02Ani,
                          currentWidth: currentWidth,
                        )
                      : const SizedBox.shrink();
                case 3:
                  return project.descriptions.length > 2
                      ? description(
                          project.descriptions[2],
                          isOdd: false,
                          isActive: controller.description03Ani,
                          currentWidth: currentWidth,
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
            callToActionBtn(),
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
            callToActionBtn(customButtonStyle: CustomButtonStyle.outline48),
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

  // 콜 투 액션 버튼
  Widget callToActionBtn({CustomButtonStyle customButtonStyle = CustomButtonStyle.filled48}) {
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
          onTap: () {},
        );
      case UserCallback.typeLink:
        return CustomButton(
          customButtonStyle: customButtonStyle,
          borderRadius: BorderRadius.circular($style.corners.$24),
          color: keyColor,
          width: 122 * sizeUnit,
          text: '자세히 보기',
          onTap: () => GlobalFunction.launch(Uri.parse(typeList.last)),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
