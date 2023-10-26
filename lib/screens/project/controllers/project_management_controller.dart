import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../project_dashboard_page.dart';

class ProjectManagementController extends GetxController {
  final Map<String, Widget Function()> pageMap = {
    '대시보드': () => ProjectDashboardPage(),
    '커뮤니케이션': () => Text('커뮤니케이션'),
    '프로젝트 설정': () => Text('프로젝트 설정'),
  };
  late String pageKey = pageMap.keys.first;
  Widget get page => pageMap[pageKey]!();

  // 페이지 키 변경
  void onChangedPageKey(String key){
    pageKey = key;
    update();
  }
}