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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: $style.colors.lightGrey,
        padding: EdgeInsets.all($style.insets.$40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '대시보드',
              style: $style.text.headline32,
            ),
            Text(
              '프로젝트 정보 확인 및 수정이 가능합니다',
              style: $style.text.body16,
            ),
            Gap(24 * sizeUnit),
            contentsArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40 * sizeUnit,
                    child: Text(
                      '프로젝트 정보',
                      style: $style.text.subTitle20,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                  Gap($style.insets.$12),
                  dashboardWidget(
                    '프로젝트 이름',
                    project.name,
                  ),
                  Gap($style.insets.$20),
                  dashboardWidget(
                    '프로젝트 URL',
                    project.getUrl,
                    () {
                      Get.toNamed('${Routes.project}/${project.documentID}', arguments: project);
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
            ),
            Gap($style.insets.$20),
            contentsArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40 * sizeUnit,
                    child: Text(
                      '프로젝트 수정',
                      style: $style.text.subTitle20,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                  Gap($style.insets.$12),
                  Container(
                    width: 120 * sizeUnit,
                    //height: 28 * sizeUnit,
                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.primary)),
                    child: TextButton(
                        onPressed: () => Get.toNamed(Routes.modifyProject, arguments: project),
                        child: Text(
                          '프로젝트 수정',
                          style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column dashboardWidget(String label, String contents, [GestureTapCallback? onTap]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: $style.text.subTitle16,
        ),
        Gap($style.insets.$4),
        Container(
          padding: EdgeInsets.all($style.insets.$8),
          //width: 280 * sizeUnit,
          constraints: BoxConstraints(
            minWidth: 800 * sizeUnit,
            minHeight: 44 * sizeUnit,
          ),
          height: 38 * sizeUnit,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular($style.corners.$4),
            border: Border.all(color: $style.colors.barrierColor),
          ),
          child: InkWell(
            onTap: onTap,
            child: Text(
              contents,
              style: $style.text.subTitle18,
            ),
          ),
        ),
      ],
    );
  }

  Container contentsArea({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all($style.insets.$16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular($style.corners.$8),
        border: Border.all(color: $style.colors.lightGrey),
      ),
      child: child,
    );
  }
}
