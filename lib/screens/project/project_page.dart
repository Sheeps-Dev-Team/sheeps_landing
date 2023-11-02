import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/default_template.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';

import '../../config/routes.dart';
import '../../util/components/custom_app_bar.dart';
import '../../util/components/like_button.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({super.key, this.isIndex = false});

  final bool isIndex;

  final ProjectController controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: GetBuilder<ProjectController>(
        initState: (state) => controller.initState(isIndex: isIndex),
        builder: (_) {
          if (controller.isLoading) return Center(child: CircularProgressIndicator(color: $style.colors.primary));

          final bool isDesktop = Responsive.isDesktop(context);
          late final Widget template;

          switch (controller.project.templateID) {
            case DefaultTemplate.id:
              template = DefaultTemplate(project: controller.project);
              break;
            default:
              template = DefaultTemplate(project: controller.project);
              break;
          }

          return Scaffold(
            appBar: appBar(isDesktop),
            body: Center(
              child: SizedBox(
                width: controller.isDesktopView ? double.infinity : 360 * sizeUnit,
                child: template,
              ),
            ),
            floatingActionButton: controller.isTmp
                ? isDesktop
                    ? FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: controller.onChangedView,
                        child: Icon(
                          controller.isDesktopView ? Icons.phone_iphone_outlined : Icons.desktop_mac_outlined,
                          size: 32 * sizeUnit,
                          color: controller.keyColor,
                        ),
                      )
                    : null
                : Obx(() => LikeButton(
                      isChecked: controller.isLike.value,
                      color: controller.isLike.value ? controller.keyColor : $style.colors.grey,
                      count: controller.project.likeCount,
                      onTap: controller.likeFunc,
                    )),
          );
        },
      ),
    );
  }

  PreferredSizeWidget appBar(bool isDesktop) {
    if (isIndex) {
      return const SiteAppBar();
    } else {
      return CustomAppBar(
        leading: controller.isTmp ? null : const SizedBox.shrink(),
        height: isDesktop ? 72 * sizeUnit : null,
        actions: controller.isTmp
            ? [
                InkWell(
                  onTap: controller.isModify ? controller.modifyProject : controller.createProject,
                  child: Text(
                    controller.isModify ? '수정하기' : '생성하기',
                    style: $style.text.subTitle16.copyWith(color: controller.colorScheme.onSurface),
                  ),
                ),
                Gap($style.insets.$16),
              ]
            : null,
        title: controller.project.name,
        surfaceTintColor: controller.keyColor,
      );
    }
  }
}
