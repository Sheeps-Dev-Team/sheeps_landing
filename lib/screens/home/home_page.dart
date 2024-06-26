import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/controllers/default_template_controller.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../data/models/project.dart';
import '../../util/components/base_widget.dart';
import 'controllers/home_page_controller.dart';
import 'dart:ui' as ui;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktopToFont(context);

    return BaseWidget(
      child: GetBuilder<HomePageController>(
        builder: (_) {
          return Scaffold(
            appBar: const SiteAppBar(),
            body: GetBuilder<HomePageController>(
                id: 'table',
                initState: (_) => controller.init(),
                builder: (_) {
                  return GridView.builder(
                    padding: EdgeInsets.all(isDesktop ? 24 * sizeUnit : 16 * sizeUnit),
                    itemCount: controller.list.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : Responsive.isTablet(context)
                              ? 3
                              : 4,
                      childAspectRatio: !Responsive.isMobile(context) ? 4 / 3 : 3.6 / 3.4,
                      mainAxisSpacing: isDesktop ? 40 * sizeUnit : 16 * sizeUnit,
                      crossAxisSpacing: isDesktop ? 40 * sizeUnit : 16 * sizeUnit,
                    ),
                    itemBuilder: (context, index) {
                      if (controller.list.isEmpty) {
                        return addProjectItem(isDesktop);
                      } else {
                        if (index == (controller.list.length)) {
                          return addProjectItem(isDesktop);
                        }
                        return projectItem(controller.list[index], isDesktop);
                      }
                    },
                  );
                }),
          );
        },
      ),
    );
  }

  Widget projectItem(Project project, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular($style.insets.$12),
              color: $style.colors.lightGrey,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: ClipRRect(
                borderRadius: BorderRadius.circular($style.insets.$12),
                child: Center(
                  child: FutureBuilder<ui.Image>(
                    future: GlobalFunction.getImage(project.imgPath),
                    builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                      if (snapshot.hasData) {
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ImageNetwork(
                            image: project.imgPath,
                            height: isDesktop ? 270 * sizeUnit : 170 * sizeUnit,
                            width: isDesktop ? 500 * sizeUnit : 300 * sizeUnit,
                            fitWeb: BoxFitWeb.cover,
                            onTap: () {
                              Get.toNamed('${Routes.project}/${project.documentID}', arguments: project);
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            width: 24 * sizeUnit,
                            height: 24 * sizeUnit,
                            child: CircularProgressIndicator(strokeWidth: 2 * sizeUnit, color: $style.colors.primary),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap($style.insets.$4),
                    Text(project.name, style: isDesktop ? $style.text.subTitle16 : $style.text.subTitle12),
                    Gap($style.insets.$2),
                    Text(GlobalFunction.getDateTimeToString(project.updatedAt),
                        style: isDesktop ? $style.text.body12.copyWith(color: $style.colors.darkGrey) : $style.text.body10.copyWith(color: $style.colors.darkGrey)),
                  ],
                ),
              ),
              CustomButton(
                customButtonStyle: isDesktop ? CustomButtonStyle.outline28 : CustomButtonStyle.outline20,
                width: (isDesktop ? 80 : 48) * sizeUnit,
                text: '관리',
                onTap: () => Get.toNamed(
                  '${Routes.projectManagement}/${project.documentID}',
                  arguments: project,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addProjectItem(bool isDesktop) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular($style.insets.$12),
            onTap: () => Get.toNamed(Routes.createProject),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: $style.colors.grey),
                borderRadius: BorderRadius.circular($style.corners.$12),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                GlobalAssets.svgPlus,
                width: isDesktop ? 100 * sizeUnit : 40 * sizeUnit,
                colorFilter: ColorFilter.mode(
                  $style.colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
