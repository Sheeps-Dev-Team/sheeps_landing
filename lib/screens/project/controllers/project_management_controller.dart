import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/global_assets.dart';

import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../project_dashboard_page.dart';

class ProjectManagementController extends GetxController {
  final Map<String, Widget Function()> pageMap = {
    '대시보드': () => ProjectDashboardPage(),
    '커뮤니케이션': () => Text('커뮤니케이션'),
    '프로젝트 설정': () => Text('프로젝트 설정'),
  };
  late String pageKey = pageMap.keys.first;

  Widget get page => pageMap[pageKey]!();

  final project = Project(
    userDocumentID: '',
    name: '',
    title: '',
    contents: '',
    imgPath: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

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
    'GlobalAssets.svgDashboard',
    'GlobalAssets.svgCommunication',
    'GlobalAssets.svgProjectSettings',
  ];

  // 페이지 키 변경
  void onChangedPageKey(String key) {
    pageKey = key;
    update();
  }
}
