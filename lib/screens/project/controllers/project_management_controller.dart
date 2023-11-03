import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/screens/project/project_settings_page.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../project_communication_page.dart';
import '../project_dashboard_page.dart';

class ProjectManagementController extends GetxController {
  late final Map<String, Widget Function()> pageMap = {
    '대시보드': () => ProjectDashboardPage(project: project),
    '커뮤니케이션': () => ProjectCommunicationPage(project: project),
    '프로젝트 설정': () => ProjectSettingsPage(project: project),
  };
  late String pageKey = pageMap.keys.first;

  Widget get page => pageMap[pageKey]!();

  late final Project project;

  final user = User(
    email: '',
    loginType: 0,
    name: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void onInit() async {
    super.onInit();

    // 직접 접근 차단
    if (GlobalFunction.blockDirectAccess()) return;

    Project? tmpProject = Get.arguments;

    if (tmpProject != null) {
      project = tmpProject;
    } else {
      GlobalFunction.goToBack();
    }
  }

  // 페이지 키 변경
  void onChangedPageKey(String key) {
    pageKey = key;
    update();
  }
}
