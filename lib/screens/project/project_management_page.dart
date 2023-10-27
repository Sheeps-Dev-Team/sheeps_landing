import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/custom_app_bar.dart';

import '../../config/constants.dart';

class ProjectManagementPage extends StatelessWidget {
  ProjectManagementPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

  @override
  Widget build(BuildContext context) {
    print(Get.parameters['id']);
    return BaseWidget(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: GetBuilder<ProjectManagementController>(builder: (_) {
          return Row(
            children: [
              sideBar(),
              Expanded(
                child: controller.page,
              ),
            ],
          );
        }),
      ),
    );
  }

  Container sideBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: $style.colors.lightGrey,
          ),
        ),
      ),
      width: 300 * sizeUnit,
      height: double.infinity,
      child: Column(
        children: List.generate(controller.pageMap.length, (index) {
          final String key = controller.pageMap.keys.toList()[index];
          return ListTile(
            focusColor: $style.colors.primary,
            hoverColor: $style.colors.primary.withOpacity(0.3),
            title: Text(
              key,
              style: $style.text.subTitle18,
              textAlign: TextAlign.center,
            ),
            onTap: () => controller.onChangedPageKey(key),
          );
        }),
      ),
    );
  }
}

