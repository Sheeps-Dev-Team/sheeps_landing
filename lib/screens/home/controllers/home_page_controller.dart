import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/repository/project_repository.dart';

import '../../../config/global_assets.dart';
import '../../../data/models/project.dart';

class HomePageController extends GetxController {

  List<Project> list = [];
}
