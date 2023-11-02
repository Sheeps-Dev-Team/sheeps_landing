import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';

import '../../config/routes.dart';

class ProjectDashboardPage extends StatelessWidget {
  const ProjectDashboardPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all($style.insets.$20),
        padding: EdgeInsets.all($style.insets.$30),
        decoration: BoxDecoration(
          boxShadow: $style.boxShadows.bs1,
          color: Colors.white,
          border: Border.all(color: $style.colors.primary),
          borderRadius: BorderRadius.circular($style.corners.$12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                dashboardWidget(
                  '프로젝트 이름',
                  project.name,
                ),
                Gap($style.insets.$20),
                dashboardWidget(
                  '프로젝트 URL',
                  project.getUrl,
                  () {
                    Get.toNamed('${Routes.project}/${project.documentID}');
                  },
                ),
                Gap($style.insets.$20),
                dashboardWidget(
                  'Call To Action 타입',
                  project.callbackType.split(division).first,
                ),
                Gap($style.insets.$20),
                dashboardWidget(
                  '유입 수',
                  project.viewCount.toString(),
                ),
                Gap($style.insets.$20),
                dashboardWidget(
                  '좋아요 수',
                  '20',
                ),
              ],
            ),
            Gap($style.insets.$20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  customButtonStyle: CustomButtonStyle.outline32,
                  text: '프로젝트 수정',
                  width: 120 * sizeUnit,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row dashboardWidget(String label, String contents, [GestureTapCallback? onTap]) {
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
            child: InkWell(
              onTap: onTap,
              child: Text(
                contents,
                style: $style.text.subTitle18,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
