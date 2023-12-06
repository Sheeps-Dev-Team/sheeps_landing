import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/default_template.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';

import '../../config/routes.dart';
import '../../util/components/custom_app_bar.dart';
import '../../util/components/like_button.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({super.key, this.isIndex = false});

  final bool isIndex;

  final ProjectController controller = Get.put(ProjectController(), tag: Get.parameters['id']);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: GetBuilder<ProjectController>(
        tag: Get.parameters['id'],
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
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: controller.isDesktopView ? double.infinity : 360 * sizeUnit,
                    child: template,
                  ),
                ),
                if(controller.isTmp)...[
                  Positioned(
                    bottom: 16 * sizeUnit,
                    child: CustomButton(
                      customButtonStyle: CustomButtonStyle.filled48,
                      width: 360 * sizeUnit,
                      color: controller.keyColor,
                      text: controller.isModify ? '수정완료' : '생성하기',
                      onTap: controller.isModify ? controller.modifyProject : controller.createProject,
                    ),
                  ),
                ],
                if( (false ==controller.isTmp) && (controller.project.orderID.isEmpty || controller.project.orderID == '')) ... [
                  Positioned(
                    bottom: 0 * sizeUnit,
                    child:
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.createProject);
                      },
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60 * sizeUnit,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 16 * sizeUnit,
                            ),
                          ],
                        ),
                        child:
                        Responsive.isDesktopToFont(context) ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sheeps Landing', style: $style.text.headline16,),
                            Text(' 이 사이트는 5분 만에 만드는 쉽스랜딩으로 제작되었습니다.',style: $style.text.body16,),
                            Gap(10 * sizeUnit),
                            CustomButton(
                              customButtonStyle: CustomButtonStyle.filled32,
                              width: 100 * sizeUnit,
                              color: controller.keyColor,
                              text: '무료 시작하기',
                              onTap: () {
                                Get.toNamed(Routes.createProject);
                              },
                            ),
                          ],
                        )

                        : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Gap(20 * sizeUnit),
                                Text('이 사이트는 5분 만에 만드는 ',style: $style.text.body14,),
                                Text('Sheeps Landing', style: $style.text.headline14),
                                Text('으로 제작되었습니다.',style: $style.text.body14,),
                              ],
                            ),
                      ),
                    ),
                  )
                ]
              ],
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
                : Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 60 * sizeUnit),
                  child: LikeButton(
                        isChecked: controller.isLike.value,
                        color: controller.isLike.value ? controller.keyColor : $style.colors.grey,
                        count: controller.project.likeCount,
                        onTap: controller.likeFunc,
                      ),
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
        title: controller.project.name,
        surfaceTintColor: controller.keyColor,
      );
    }
  }
}
