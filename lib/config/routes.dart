import 'package:get/get.dart';
import 'package:sheeps_landing/screens/home/home_page.dart';
import 'package:sheeps_landing/screens/home/splash_screen.dart';
import 'package:sheeps_landing/screens/login/login_page.dart';
import 'package:sheeps_landing/screens/project/create_project_page.dart';
import 'package:sheeps_landing/screens/project/project_page.dart';

import '../screens/project/project_management_page.dart';


class Routes {
  static const String index = '/';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String createProject = '/project/create';
  static const String modifyProject = '/project/modify';
  static const String projectManagement = '/project/management';
  static const String login = '/login';
  static const String project = '/project';

  static List<GetPage<dynamic>> getPages = [
    GetPage(name: index, page: () => ProjectPage(isIndex: true)),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: createProject, page: () => CreateProjectPage()),
    GetPage(name: modifyProject, page: () => CreateProjectPage(isModify: true)),
    GetPage(name: '$projectManagement/:id', page: () => ProjectManagementPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: '$project/:id', page: () => ProjectPage()),
  ];
}