import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/project/project_page.dart';
import 'package:sheeps_landing/screens/template/controllers/default_template_controller.dart';
import 'package:sheeps_landing/screens/template/default_template.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../data/models/project.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/get_extended_image.dart';
import 'controllers/home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.symmetric(horizontal: 24 * sizeUnit, vertical: 24 * sizeUnit),
                    itemCount: controller.list.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : Responsive.isTablet(context)
                              ? 3
                              : 4,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 40 * sizeUnit,
                      crossAxisSpacing: 40 * sizeUnit,
                    ),
                    itemBuilder: (context, index) {
                      if (controller.list.isEmpty) {
                        return addProjectItem();
                      } else {
                        if (index == (controller.list.length)) {
                          return addProjectItem();
                        }
                        return projectItem(controller.list[index]);
                      }
                    },
                  );
                }),
          );
        },
      ),
    );
  }

  Widget projectItem(Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular($style.insets.$12),
            onTap: () {
              Get.delete<ProjectController>();
              Get.delete<DefaultTemplateController>();

              if (kDebugMode) {
                Get.toNamed('${Routes.project}/${project.documentID == '' ? 'N1Z1RfyvMRfz52SP2K4g' : project.documentID}', arguments: project);
              } else {
                Get.toNamed('${Routes.project}/${project.documentID}', arguments: project);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular($style.insets.$12),
              child: Center(
                child: GetExtendedImage(
                  url: project.imgPath,
                  fit: BoxFit.contain,
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
                    Text(
                      project.name,
                      style: $style.text.subTitle16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap($style.insets.$2),
                    Text(
                      GlobalFunction.getDateTimeToString(project.updatedAt),
                      style: $style.text.body12.copyWith(color: $style.colors.darkGrey),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80 * sizeUnit,
                height: 30 * sizeUnit,
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12 * sizeUnit), border: Border.all(color: $style.colors.primary)),
                child: TextButton(
                    onPressed: () {
                      if (kDebugMode) {
                        Get.toNamed('${Routes.projectManagement}/${project.documentID == '' ? 'N1Z1RfyvMRfz52SP2K4g' : project.documentID}');
                      } else {
                        Get.toNamed('${Routes.projectManagement}/${project.documentID}');
                      }
                    },
                    child: Text(
                      '관리',
                      style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget addProjectItem() {
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
                width: 100 * sizeUnit,
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
