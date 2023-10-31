import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';

class DefaultTemplateController extends GetxController {
  late final Project project;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int scrollIndex = 0;
  double distance = 60 * sizeUnit;

  bool headerAni = false;
  bool description01Ani = false;
  bool description02Ani = false;
  bool description03Ani = false;
  bool callToActionAni = false;

  @override
  void onInit() {
    super.onInit();

    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.isNotEmpty && itemScrollController.isAttached) {
        final int idx = itemPositionsListener.itemPositions.value
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) => position.itemTrailingEdge < min.itemTrailingEdge * 2.2 ? position : min)
            .index;

        if (scrollIndex != idx) {
          scrollIndex = idx;
          aniFunc();
        }
      }
    });
  }

  void initState(Project project) {
    this.project = project;

    headerAni = true;
    description01Ani = true;
    update();
  }

  void aniFunc() {
    switch (scrollIndex) {
      case 0:
        headerAni = true;
        break;
      case 1:
        description01Ani = true;
        break;
      case 2:
        description02Ani = true;
        break;
      case 3:
        description03Ani = true;
        break;
      case 4:
        callToActionAni = true;
        break;
    }

    update();

    if (kDebugMode) print('scrollIndex: $scrollIndex');
  }
}
