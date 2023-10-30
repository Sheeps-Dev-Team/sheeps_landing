import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';

class ProjectDashboardPage extends StatelessWidget {
  ProjectDashboardPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.all($style.insets.$20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: $style.colors.barrierColor,
            //color: $style.colors.primary/*.withOpacity(0.1)*/,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 7),
          ),
        ],
        color: Colors.white,
        border: Border.all(color: $style.colors.primary),
        borderRadius: BorderRadius.circular($style.corners.$12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all($style.insets.$30),
            width: double.infinity,
            child: Column(
              children: [
                dashboardWidget('프로젝트 이름', controller.project.name),
                Gap($style.insets.$20),
                dashboardWidget('프로젝트 URL', controller.project.url),
                Gap($style.insets.$20),
                dashboardWidget('Call To Action 타입', controller.project.callbackType),
                Gap($style.insets.$20),
                dashboardWidget('유입 수', controller.project.viewCount.toString()),
                Gap($style.insets.$20),
              ],
            ),
          ),
          Gap($style.insets.$20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                customButtonStyle: CustomButtonStyle.outline48,
                text: '프로젝트 수정하기',
                width: 200,
                onTap: () {},
              ),
              SizedBox(
                width: 135 * sizeUnit,
              )
            ],
          ),
        ],
      ),
    ));
  }

  Row dashboardWidget(String label, String contents) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200 * sizeUnit,
          child: Text(
            label,
            style: $style.text.headline20,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: $style.insets.$8),
            height: 44 * sizeUnit,
            decoration: BoxDecoration(
              border: Border.all(width: 1 * sizeUnit, color: $style.colors.primary),
              borderRadius: BorderRadius.circular($style.corners.$12),
            ),
            child: Text(
              contents,
              style: $style.text.subTitle18,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}


/*Table(
              //border: TableBorder.all(),
              //defaultColumnWidth: FixedColumnWidth(600 * sizeUnit), // 각 열의 너비를 200.0으로 설정
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: EdgeInsets.all($style.insets.$10),
                      child: dashboardWidget('프로젝트 이름', controller.project.name),
                    )),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: EdgeInsets.all($style.insets.$10),
                      child: dashboardWidget('프로젝트 URL', controller.project.url),
                    )),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: EdgeInsets.all($style.insets.$10),
                      child: dashboardWidget('Call To Action 타입', controller.project.callbackType),
                    )),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: EdgeInsets.all($style.insets.$10),
                      child: dashboardWidget('유입 수', controller.project.viewCount.toString()),
                    )),
                  ],
                ),
              ],
            ),*/