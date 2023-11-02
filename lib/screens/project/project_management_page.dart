import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';

import '../../config/constants.dart';
import '../../util/components/site_app_bar.dart';

class ProjectManagementPage extends StatelessWidget {
  ProjectManagementPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        appBar: const SiteAppBar(),
        body: GetBuilder<ProjectManagementController>(
            builder: (_) {
              return Row(
                children: [
                  sideMenu(),
                  Expanded(
                    child: controller.page,
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  //사이드바
  Container sideMenu() {
    return Container(
      margin: EdgeInsets.only(top: $style.insets.$8),
      width: 240 * sizeUnit,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(controller.pageMap.length, (index) {
          final String key = controller.pageMap.keys.toList()[index];

          return menuListItem(
            key,
            onPressedFunc: () {
              controller.onChangedPageKey(key);
            },
          );
        }),
      ),
    );
  }

  //사이드바 메뉴
  Widget menuListItem(String text, {required Function onPressedFunc}) {
      final bool isSelected = controller.pageKey == text; // 현재 항목의 선택 상태 확인

      return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                highlightColor: $style.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular($style.corners.$12)),
                onTap: (){
                  onPressedFunc();
                },
                hoverColor: const Color.fromRGBO(243, 237, 246, 0.5),
                child: Container(
                  width: double.infinity,
                  height: 32 * sizeUnit,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: $style.insets.$16),
                  decoration: BoxDecoration(
                    color: isSelected ? $style.colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular($style.corners.$12),
                    border: Border.all(color: $style.colors.primary),
                  ),
                  child: Row(
                    children: [
                      Text(
                        text,
                        style: $style.text.body14.copyWith(color: isSelected ? Colors.white : $style.colors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap($style.insets.$12),
          ],
        ),
      );
  }
}
