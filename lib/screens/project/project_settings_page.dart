import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/screens/home/controllers/home_page_controller.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../util/components/responsive.dart';

class ProjectSettingsPage extends StatelessWidget {
  const ProjectSettingsPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '프로젝트 설정',
                style: isDesktop ? $style.text.headline32 : $style.text.headline20,
              ),
              Text(
                '프로젝트 관련 설정이 가능합니다.',
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
                        '프로젝트 삭제',
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
                      //height: 28 * sizeUnit,
                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.red)),
                      child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all($style.colors.red.withOpacity(0.1)),
                          ),
                          onPressed: () {
                            GlobalFunction.showCustomDialog(
                                title: '정말 삭제하시겠어요?',
                                description: '삭제하면 데이터를 복원할 수 없어요.',
                                showCancelBtn: true,
                                okText: '삭제',
                                okFunc: () async {
                                  Get.close(1); // 다이얼로그 끄기

                                  GlobalFunction.loadingDialog(); // 로딩 시작
                                  final bool isDeleted = await ProjectRepository.deleteProject(project);
                                  Get.close(1); // 로딩 끝

                                  // 삭제 성공 시
                                  if (isDeleted) {
                                    final HomePageController homeController = Get.find<HomePageController>();

                                    // 홈 페이지에서 프로젝트 삭제
                                    homeController.list.removeWhere((element) => element.documentID == project.documentID);
                                    homeController.update();

                                    Get.back(); // 홈 페이지로 이동
                                  } else {
                                    // 삭제 실패 시
                                    GlobalFunction.showToast(msg: '잠시 후 다시 시도해 주세요.');
                                  }
                                });
                          },
                          child: Text(
                            '프로젝트 삭제',
                            style: $style.text.subTitle14.copyWith(color: $style.colors.red),
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
