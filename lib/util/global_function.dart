import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/constants.dart';
import '../config/routes.dart';
import '../data/global_data.dart';
import '../data/models/user.dart';
import '../repository/user_repository.dart';

class GlobalFunction {
  // 포커스 해제 함수
  static void unFocus() {
    FocusManager.instance.primaryFocus!.unfocus();
  }

  // 다이얼로그
  static Future<void> showCustomDialog({
    Widget? child,
    String title = '',
    String description = '',
    String okText = '확인',
    String cancelText = '취소',
    bool showCancelBtn = false,
    GestureTapCallback? okFunc,
    GestureTapCallback? cancelFunc,
    bool barrierDismissible = true,
  }) {
    // 버튼
    Widget button({required String text, required GestureTapCallback onTap, required Color bgColor, required Color borderColor, required Color fontColor}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular($style.corners.$12),
          child: Container(
            width: double.infinity,
            height: 48 * sizeUnit,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular($style.corners.$12),
              border: Border.all(color: borderColor, width: 1 * sizeUnit),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: $style.text.subTitle16.copyWith(color: fontColor),
            ),
          ),
        ),
      );
    }

    return Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: 300 * sizeUnit,
            margin: EdgeInsets.symmetric(horizontal: $style.insets.$40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular($style.corners.$12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24 * sizeUnit),
                if (title.isNotEmpty) Text(title, style: $style.text.subTitle16),
                if (child != null) ...[
                  child,
                ] else ...[
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 12 * sizeUnit),
                    Text(
                      description,
                      style: $style.text.body14,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
                SizedBox(height: 24 * sizeUnit),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 * sizeUnit),
                  child: Row(
                    children: [
                      if (showCancelBtn) ...[
                        Expanded(
                          child: button(
                            text: cancelText,
                            bgColor: Colors.white,
                            borderColor: $style.colors.primary,
                            fontColor: $style.colors.primary,
                            onTap: cancelFunc ?? () => Get.back(),
                          ),
                        ),
                        SizedBox(width: 8 * sizeUnit),
                      ],
                      Expanded(
                        child: button(
                          text: okText,
                          bgColor: $style.colors.primary,
                          borderColor: $style.colors.primary,
                          fontColor: Colors.white,
                          onTap: okFunc ?? () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16 * sizeUnit),
              ],
            ),
          ),
        ),
      ),
      barrierColor: $style.colors.barrierColor,
      barrierDismissible: barrierDismissible,
    );
  }

  // 토스트
  static void showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: $style.colors.primary,
      textColor: Colors.white,
    );
  }

  // date picker
  static Future<DateTime> datePicker({required BuildContext context, DateTime? initialDateTime, DateTime? minimumDateTime}) async {
    unFocus(); // 포커스 해제

    final DateTime now = DateTime.now();
    final DateTime initDateTime = initialDateTime ?? now;
    DateTime? date;

    await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 200 * sizeUnit,
              width: double.infinity,
              color: Colors.white,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                initialDateTime: initDateTime,
                mode: CupertinoDatePickerMode.date,
                minimumDate: minimumDateTime,
                maximumYear: now.year,
                onDateTimeChanged: (val) => date = val,
              ),
            ));

    date ??= initDateTime;
    return DateTime(date!.year, date!.month, date!.day, 12);
  }

  // 실명 유효성 검사
  static String? validRealNameErrorText(String name) {
    String? errMsg;

    final RegExp regExp = RegExp(r'(^[가-힣]{2,10}$)'); // 2 ~ 10개 한글 입력가능
    if (!regExp.hasMatch(name)) errMsg = '이름을 정확히 입력해 주세요.';
    return errMsg;
  }

  // 핸드폰 유효성 검사
  static String? validPhoneNumErrorText(String number) {
    String? errMsg;

    final RegExp regExp = RegExp(r'^\d{10,11}$'); // 10 ~ 11개 숫자 입력가능
    if (!regExp.hasMatch(number)) errMsg = '휴대폰 번호를 정확히 입력해 주세요.';
    return errMsg;
  }

  // 이메일 유효성 검사
  static String? validEmailErrorText(String email) {
    String? errMsg;

    final RegExp regExp = RegExp(r'^[0-9a-zA-Z][0-9a-zA-Z\_\-\.\+]+[0-9a-zA-Z]@[0-9a-zA-Z][0-9a-zA-Z\_\-]*[0-9a-zA-Z](\.[a-zA-Z]{2,6}){1,2}$');

    if (email.length < 6) {
      errMsg = "최소 6글자 이상의 이메일이어야 해요.";
    } else if (!regExp.hasMatch(email)) {
      errMsg = "메일 형식에 맞게 입력해 주세요.";
    }

    return errMsg;
  }

  // 로딩 다이어로그
  static void loadingDialog({Color? color}) {
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(color: color ?? $style.colors.primary),
        ),
      ),
    );
  }

  // 파일크기 측정
  static Future<bool> isBigFile(XFile file) async {
    int fileSize = await file.length();

    //약 15mb
    if (fileSize >= 15882755) return Future.value(true);
    return Future.value(false);
  }

  // url 연결 함수
  static Future<void> launch(Uri url) async {
    if (await canLaunchUrl(url)) {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  // 뒤로가기 (이전 라우트가 없으면 홈으로가기)
  static void goToBack() {
    if (Get.previousRoute.isEmpty) {
      Get.offAllNamed(Routes.index);
    } else {
      Get.back();
    }
  }

  // url 직접 접근 차단
  static bool blockDirectAccess() {
    if (GlobalData.loginUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(Routes.index));
      return true;
    } else {
      return false;
    }
  }

  static String getDateTimeToString(DateTime date) {
    String res = date.toString();

    return '${res.substring(0, 4)}년 ${res.substring(5, 7)}월 ${res.substring(8, 10)}일';
  }

  static Future<bool> globalLogin() async {
    GoogleSignInAccount? currentUser;
    var errCheck = false;

    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: scopes,
    );

    try {
      currentUser = await googleSignIn.signIn();
      if (kDebugMode) print('Google sign-in successful.');

      if (currentUser != null) {
        GlobalData.loginUser = await UserRepository.getUserByEmail(currentUser.email);

        //없으면 새로 생성
        if (GlobalData.loginUser == null) {
          GlobalData.loginUser = await UserRepository.createUser(
            User(
                email: currentUser.email,
                loginType: LoginType.google.index,
                name: currentUser.displayName == null ? '쉽스' : currentUser.displayName!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
          );

          // 유저 생성 성공 시
          if (GlobalData.loginUser != null) {
            if (kDebugMode) debugPrint('create user call');

            if (kDebugMode) debugPrint(GlobalData.loginUser!.documentID);
          } else {
            // 유저 생성 실패 시
            if (kDebugMode) debugPrint('유저 생성 실패');
            errCheck = true;
          }
        } else {
          if (kDebugMode) debugPrint('is not empty');
        }
      }
    } catch (error) {
      errCheck = true;
      if (kDebugMode) print(error);
    }

    // 자동 로그인 정보 저장
    if (GlobalData.loginUser != null) {
      const storage = FlutterSecureStorage();

      await storage.write(key: 'email', value: GlobalData.loginUser!.email);
      await storage.write(key: 'loginType', value: GlobalData.loginUser!.loginType.toString());
    }

    return errCheck;
  }

  // 로그아웃
  static Future<void> logout() async {
    GlobalData.loginUser = null;
    // 자동 로그인 정보 삭제
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'email');
    await storage.delete(key: 'loginType');

    Get.offAllNamed(Routes.index);
  }

  // 키 컬러 호환 컬러
  static ColorScheme getColorScheme(Color keyColor) {
    ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: keyColor);

    if (keyColor == Colors.black) {
      colorScheme = ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.black.withOpacity(0.04),
        secondary: Colors.black.withOpacity(0.04),
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black.withOpacity(0.04),
        background: Colors.black.withOpacity(0.04),
        onBackground: Colors.black,
        surface: Colors.black.withOpacity(0.04),
        onSurface: Colors.black,
      );
    }
    return colorScheme;
  }
}
