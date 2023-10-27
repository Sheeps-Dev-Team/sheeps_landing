import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/models/user.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config/constants.dart';
import 'config/style.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

  setPathUrlStrategy(); //url # 제거
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    setSizeUnit(); // 사이즈 유닛 세팅
  }

  // 사이즈 유닛 세팅
  void setSizeUnit() async {
    if(kIsWeb) {
      sizeUnit = 1;
      return;
    }

    sizeUnit = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding
            .instance.platformDispatcher.views.first.devicePixelRatio /
        360;

    if (sizeUnit == 0) {
      if (kDebugMode) debugPrint('reset sizeUnit!');

      await Future.delayed(const Duration(milliseconds: 500), () {
        sizeUnit = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
            WidgetsBinding
                .instance.platformDispatcher.views.first.devicePixelRatio /
            360;
        if (sizeUnit == 0) sizeUnit = 1;
      });

      if (kDebugMode) debugPrint("size unit is $sizeUnit");
      MyApp._style = AppStyle(sizeUnit: sizeUnit); // 스타일 세팅
    } else {
      if (kDebugMode) debugPrint("size unit is $sizeUnit");
      MyApp._style = AppStyle(sizeUnit: sizeUnit); // 스타일 세팅
    }

    // 큰 사이즈 기기 대응
    if(sizeUnit >= 1.8) {
      sizeUnit = 1.2;
      MyApp._style = AppStyle(sizeUnit: sizeUnit); // 스타일 세팅
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sheeps Landing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: $style.colors.primary),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      initialRoute: Routes.splash,
      getPages: Routes.getPages,
    );
  }
}

// 스크롤 관리
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    // PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
