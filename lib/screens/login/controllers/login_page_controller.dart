import 'dart:async';
import 'dart:convert' show json;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/data/models/user.dart';
import 'package:sheeps_landing/repository/user_repository.dart';

import '../../../config/global_assets.dart';

class LoginPageController extends GetxController {
  GoogleSignInAccount? currentUser;

  Future<bool> loginFunc() async {
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
      if (kDebugMode) {
        print('Google sign-in successful.');
      }

      if (currentUser != null) {
        GlobalData.loginUser = await UserRepository.getUserByEmail(currentUser!.email);

        //없으면 새로 생성
        if (GlobalData.loginUser == null) {
          GlobalData.loginUser = await UserRepository.createUser(
              User(email: currentUser!.email, loginType: 0, name: currentUser!.displayName == null ? '쉽스' : currentUser!.displayName!, createdAt: DateTime.now(), updatedAt: DateTime.now()));
          debugPrint('create user call');
        } else {
          debugPrint('is not empty');
        }
        debugPrint(GlobalData.loginUser!.documentID);

        // 자동 로그인 정보 저장
        const storage = FlutterSecureStorage();

        await storage.write(key: 'email', value: GlobalData.loginUser!.email);
        await storage.write(key: 'loginType', value: GlobalData.loginUser!.loginType.toString());
      }
    } catch (error) {
      errCheck = true;
      if (kDebugMode) {
        print(error);
      }
    }

    update();

    return errCheck;
  }

  // 자동 로그인
  Future<bool> autoLogin() async {
    var errCheck = false;

    try{
      const storage = FlutterSecureStorage();
      String loginType = await storage.read(key: 'loginType') ?? '';
      String email = await storage.read(key: 'email') ?? '';
      if (email.isEmpty) {
        //자동 로그인 정보 없음
      } else{
        GlobalData.loginUser = await UserRepository.getUserByEmail(currentUser!.email);

        debugPrint(GlobalData.loginUser!.documentID);
      }
    } catch (error) {
      errCheck = true;
      if (kDebugMode) {
        print(error);
      }
    }

    update();

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
