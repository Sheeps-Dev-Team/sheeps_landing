import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';

import '../../config/routes.dart';
import '../../util/components/responsive.dart';

class ProjectDashboardPage extends StatelessWidget {
  const ProjectDashboardPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      body: Padding(
        padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '대시보드',
                style: isDesktop ? $style.text.headline32 : $style.text.headline20,
              ),
              Text(
                '프로젝트 정보 확인 및 수정이 가능합니다.',
                style: isDesktop ? $style.text.body16 : $style.text.body12,
              ),
              Gap(isDesktop ? $style.insets.$24 : $style.insets.$12),
              contentsArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '프로젝트 정보',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
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
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      '프로젝트 URL',
                      project.getUrl,
                      isDesktop,
                      () {
                        Get.toNamed('${Routes.project}/${project.documentID}', arguments: project);
                      },
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      'Call To Action 타입',
                      project.callbackType.split(division).first,
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      '조회 수',
                      project.viewCount.toString(),
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      '좋아요 수',
                      project.likeCount.toString(),
                      isDesktop,
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
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '프로젝트 수정',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
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
      ),
    );
  }

  Widget dashboardWidget(String label, String contents, bool isDesktop, [GestureTapCallback? onTap]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: isDesktop ? $style.text.subTitle16 : $style.text.subTitle14,
        ),
        Gap($style.insets.$4),
        Container(
          padding: EdgeInsets.all($style.insets.$8),
          constraints: BoxConstraints(
            minWidth: 800 * sizeUnit,
            minHeight: isDesktop ? 44 * sizeUnit : 34 * sizeUnit,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular($style.corners.$4),
            border: Border.all(color: $style.colors.barrierColor),
          ),
          child: InkWell(
            onTap: onTap,
            child: Text(
              contents,
              style: isDesktop ? $style.text.subTitle18 : $style.text.body12,
              overflow: TextOverflow.ellipsis,
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
