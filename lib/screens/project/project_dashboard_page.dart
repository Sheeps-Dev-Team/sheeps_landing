import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';

class ProjectDashboardPage extends StatelessWidget {
  ProjectDashboardPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*dashboardWidget('프로젝트 이름', controller.project.value.name, true),
        Gap($style.insets.$30),
        dashboardWidget('프로젝트 URL', controller.project.value.url, true),
        Gap($style.insets.$30),
        dashboardWidget('Call To Action 타입', controller.project.value.callbackType, true),
        Gap($style.insets.$30),
        dashboardWidget('유입 수', controller.project.value.viewCount.toString(), false),*/
        Container(
          width: double.infinity,
          child: Table(
            //border: TableBorder.all(),
            defaultColumnWidth: FixedColumnWidth(600 * sizeUnit), // 각 열의 너비를 200.0으로 설정
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: EdgeInsets.all($style.insets.$10),
                    child: dashboardWidget('프로젝트 이름', $style.insets.$80, controller.project.value.name, true),
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: EdgeInsets.all($style.insets.$10),
                    child: dashboardWidget('프로젝트 URL', $style.insets.$80,controller.project.value.url, true),
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: EdgeInsets.all($style.insets.$10),
                    child: dashboardWidget('Call To Action 타입', $style.insets.$16, controller.project.value.callbackType, true),
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: EdgeInsets.all($style.insets.$10),
                    child: dashboardWidget('유입 수', 88 * sizeUnit, controller.project.value.viewCount.toString(), false),
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Row dashboardWidget(String text, gap, String projectName, bool haveBtn) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200 * sizeUnit,
          child: Text(
            text,
            style: $style.text.headline20,
          ),
        ),
        // Gap(gap),
        Container(
          padding: EdgeInsets.symmetric(vertical: $style.insets.$8),
          width: 800 * sizeUnit,
          height: 44 * sizeUnit,
          decoration: BoxDecoration(
            border: Border.all(width: 1 * sizeUnit, color: $style.colors.primary),
            borderRadius: BorderRadius.circular($style.corners.$12),
          ),
          child: Text(
            projectName,
            style: $style.text.subTitle18,
            textAlign: TextAlign.center,
          ),
        ),
        Gap($style.insets.$20),
        if (haveBtn) ...{
          editBtn(),
        }
      ],
    );
  }

  InkWell editBtn() {
    return InkWell(
      child: Row(
        children: [
          Icon(
            Icons.edit,
            color: $style.colors.primary,
          ),
          Text(
            '수정',
            style: $style.text.body14.copyWith(color: $style.colors.primary),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
