import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/routes.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../../data/models/project.dart';

class HomePageController extends GetxController {
  List<Project> list = [];

  Future<void> init() async {
    // url 직접 접근 차단
    if (GlobalFunction.blockDirectAccess()) return;

    if (kDebugMode) {
      if (GlobalData.loginUser == null) {
        list.add(Project.nullProject);
      } else {
        list = await ProjectRepository.getProjectListByUserID(GlobalData.loginUser!.documentID);
      }
    } else {
      list = await ProjectRepository.getProjectListByUserID(GlobalData.loginUser!.documentID);
    }

    update();
  }
}
