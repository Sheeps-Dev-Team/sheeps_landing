import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';

import '../../config/constants.dart';

class ProjectManagementPage extends StatelessWidget {
  ProjectManagementPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        //appBar: CustomAppBar(),
        body: GetBuilder<ProjectManagementController>(builder: (_) {
          return Row(
            children: [
              sideBar(),
              Expanded(
                child: controller.isLoading ? const SizedBox.shrink() : controller.page,
              ),
            ],
          );
        }),
      ),
    );
  }

  Container sideBar() {
    return Container(
      width: 300 * sizeUnit,
      height: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.back(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              color: Colors.white, //inkwell hover 효과 안보이게 하려고
              height: 100 * sizeUnit,
              child: SvgPicture.asset(GlobalAssets.svgLogo),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black87,
                ),
              ),
            ),
            //height: 100 * sizeUnit,
            child: Column(
              children: [
                //Text(controller.user.email, style: $style.text.subTitle18,),
                Text('user@gmail.com', style: $style.text.subTitle18),
              ],
            ),
          ),
          Column(
            children: List.generate(controller.pageMap.length, (index) {
              final String key = controller.pageMap.keys.toList()[index];
              return ListTile(
                focusColor: $style.colors.primary,
                hoverColor: $style.colors.primary.withOpacity(0.3),
                leading: SvgPicture.asset(
                  controller.sidebarIcons[index],
                  width: 18 * sizeUnit,
                  height: 18 * sizeUnit,
                ),
                title: Obx(() {
                  final isSelected = controller.selectedSidebar.contains(key);
                  return Text(
                    key,
                    style: $style.text.subTitle18.copyWith(color: isSelected ? $style.colors.primary : Colors.black),
                    textAlign: TextAlign.center,
                  );
                }),
                onTap: (){
                  controller.onChangedPageKey(key);
                  controller.selectedSidebar.value = <String>[key];
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
