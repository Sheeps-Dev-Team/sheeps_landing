import 'package:get/get.dart';
import 'package:sheeps_landing/screens/home/home_page.dart';
import 'package:sheeps_landing/screens/home/splash_screen.dart';

class Routes {
  static const String home = '/';
  static const String splash = '/splash';

  static List<GetPage<dynamic>> getPages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: splash, page: () => const SplashScreen()),
  ];
}