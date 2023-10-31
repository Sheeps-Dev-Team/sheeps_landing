import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/screens/project/project_settings_page.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../project_communication_page.dart';
import '../project_dashboard_page.dart';

class ProjectManagementController extends GetxController {
  late final Map<String, Widget Function()> pageMap = {
    '대시보드': () => ProjectDashboardPage(project: project),
    '커뮤니케이션': () => ProjectCommunicationPage(userCallback: UserCallback(
      documentID: '',
      projectID: '',
      ip: '',
      phoneNumber: '',
      email: '',
      name: '',
    )
    ),
    '프로젝트 설정': () => ProjectSettingsPage(),
  };
  late String pageKey = pageMap.keys.first;

  Widget get page => pageMap[pageKey]!();

  late final Project project;
  bool isLoading = true;

  //사이드바 선택됬을때 변수
  RxList<String> selectedSidebar = <String>[].obs;

  final user = User(
    email: '',
    loginType: 0,
    name: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  //사이드바 메뉴 아이콘
  final List<String> sidebarIcons = [
    GlobalAssets.svgDashboard,
    GlobalAssets.svgCommunication,
    GlobalAssets.svgProjectSettings,
  ];

  @override
  void onInit() async{
    super.onInit();

    // 직접 접근 차단
    if(GlobalFunction.blockDirectAccess()) return;

    final String? id = Get.parameters['id'];

    if(id != null) {
      Project? res = await ProjectRepository.getProjectByID(id);
      if(res != null) {
        project = res;

        isLoading = false;
        update();
      } else {
        GlobalFunction.goToBack();
      }
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
