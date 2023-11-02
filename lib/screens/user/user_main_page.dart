import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheeps_landing/screens/user/user_setting_page.dart';

import '../../config/constants.dart';
import '../../config/global_assets.dart';
import '../../data/global_data.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/site_app_bar.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({Key? key}) : super(key: key);

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {

  UserMainPageController controller = Get.put(UserMainPageController());

  List userPage = [];

  @override
  void initState() {
    userPage = [
      const UserSettingPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BaseWidget(
      child: Scaffold(
        appBar: const SiteAppBar(),
        body: Row(
          children: [
            GetBuilder<UserMainPageController>(
                id: 'sideMenu',
                builder: (_) {
                  return sideMenu();
                }
            ),
            VerticalDivider(thickness: 1, width: 1, color: $style.colors.barrierColor,),
            Expanded(
              child: GetBuilder<UserMainPageController>(
                id: 'body',
                initState: (state) => controller.setData(),
                builder: (_) {
                  return userPage[controller.userPageIndex];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Container sideMenu() {
    return Container(
      width: 240 * sizeUnit,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52  ),
                Text(
                  '환영합니다. ',
                  style: $style.text.subTitle16.copyWith(color: $style.colors.black, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                Divider(height: 1, thickness: 1, color: $style.colors.lightGrey),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                menuListItem(
                    '계정 설정',
                    index: controller.userPageIndexSetting,
                    onPressedFunc: () {
                      controller.menuItemPressFunc(controller.userPageIndexSetting);
                    },
                    isSelected: controller.userPageIndexSetting == controller.userPageIndex
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuListItem(String text, {required int index, required Function onPressedFunc, required bool isSelected}) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: InkWell(
          onTap: onPressedFunc as void Function()?,
          hoverColor: const Color.fromRGBO(243, 237, 246, 0.5),
          child: Container(
            width: double.infinity,
            height: 32,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: isSelected ? $style.colors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular($style.corners.$12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  text,
                  style: $style.text.body14.copyWith(color: isSelected ? Colors.white: $style.colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class UserMainPageController extends GetxController {
  final int userPageIndexSetting = 0;

  int userPageIndex = 0;

  Future<void> setData() async {
    switch (userPageIndex) {
      case 0:
        {

        }
        break;
    }
  }

  void menuItemPressFunc(int index) async {
    userPageIndex = index;
    await setData();
    update(['sideMenu']);
    update(['body']);
  }
}

