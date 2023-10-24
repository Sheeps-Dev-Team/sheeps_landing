import 'package:get/get.dart';
import 'package:sheeps_landing/screens/home/home_page.dart';
import 'package:sheeps_landing/screens/home/splash_screen.dart';
import 'package:sheeps_landing/screens/project/create_project_page.dart';

class Routes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String createProject = '/project/create';

  static List<GetPage<dynamic>> getPages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: createProject, page: () => CreateProjectPage()),
  ];
}