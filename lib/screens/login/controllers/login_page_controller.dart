import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/repository/user_repository.dart';


class LoginPageController extends GetxController {
  // 자동 로그인
  Future<bool> autoLogin() async {
    var errCheck = false;

    try{
      const storage = FlutterSecureStorage();
      final String email = await storage.read(key: 'email') ?? '';

      if (email.isEmpty) {
        //자동 로그인 정보 없음
      } else{
        GlobalData.loginUser = await UserRepository.getUserByEmail(email);

        debugPrint(GlobalData.loginUser!.documentID);
      }
    } catch (error) {
      errCheck = true;
      if (kDebugMode) {
        print(error);
      }
    }

    return errCheck;
  }

  // 로그아웃
  Future<void> logout() async{

    // 자동 로그인 정보 삭제
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'email');
    await storage.delete(key: 'loginType');
  }
}
