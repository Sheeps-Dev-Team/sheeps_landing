import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/util/components/responsive.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';

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
                  itemCount: controller.list.isEmpty ? 1 : (controller.list.length + 1),
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
                    if(controller.list.isEmpty){
                      return addProjectItem();
                    }else{
                      if(index == (controller.list.length)){
                        return addProjectItem();
                      }

                      return projectItem(controller.list[index]);
                    }
                  },
                );
              }
            ),
          );
        },
      ),
    );
  }

  GestureDetector projectItem(Project project) {
    // print('${Routes.projectManagement}/1');
    return GestureDetector(
      onTap: (){Get.toNamed('${Routes.projectManagement}/${project.documentID}');},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: (){Get.toNamed('${Routes.projectManagement}/${project.documentID}');},
              child: ClipRRect(
                borderRadius: BorderRadius.circular($style.insets.$12),
                child: GetExtendedImage(
                  url: project.imgPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap($style.insets.$4),
                Text(project.name, style: $style.text.subTitle16),
                Gap($style.insets.$2),
                Text(project.updatedAt.toString().substring(0,10), style: $style.text.body12.copyWith(color: $style.colors.darkGrey)),
              ],
            ),
          ),
        ],
      ),
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
