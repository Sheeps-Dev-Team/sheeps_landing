import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sheeps_landing/screens/user/user_setting_page.dart';

import '../../config/constants.dart';
import '../../util/components/base_widget.dart';
import '../../util/components/responsive.dart';
import '../../util/components/site_app_bar.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({Key? key}) : super(key: key);


  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {

  UserMainPageController controller = Get.put(UserMainPageController());

  List userPage = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userPage = [
      const UserSettingPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return BaseWidget(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: SiteAppBar(
          centerTitle: isDesktop ? false : true,
          leading: isDesktop
              ? const SizedBox.shrink()
              : Padding(
            padding: EdgeInsets.only(left: $style.insets.$16),
            child: SizedBox(
              width: 24 * sizeUnit,
              height: 24 * sizeUnit,
              child: Center(
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer(); // Drawer 열기
                  },
                  child: Icon(
                    Icons.menu,
                    color: $style.colors.darkGrey,
                    size: 24 * sizeUnit,
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: isDesktop
            ? null
            : Drawer(
          child: GetBuilder<UserMainPageController>(
              id: 'sideMenu',
              builder: (_) {
                return sideMenu();
              }
          ),
        ),
        body: Row(
          children: [
            if(isDesktop)...{
              GetBuilder<UserMainPageController>(
                  id: 'sideMenu',
                  builder: (_) {
                    return sideMenu();
                  }
              ),
            },
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
            padding: EdgeInsets.symmetric(horizontal: $style.insets.$16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52 * sizeUnit),
                Text(
                  '환영합니다. ',
                  style: $style.text.subTitle16.copyWith(color: $style.colors.black, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 24 * sizeUnit),
                Divider(height: 1, thickness: 1, color: $style.colors.lightGrey),
              ],
            ),
          ),
          SizedBox(height: 24 * sizeUnit),
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: InkWell(
          onTap: onPressedFunc as void Function()?,
          hoverColor: const Color.fromRGBO(243, 237, 246, 0.5),
          child: Container(
            width: double.infinity,
            height: 32 * sizeUnit,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: $style.insets.$16),
            decoration: BoxDecoration(
              color: isSelected ? $style.colors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular($style.corners.$12),
            ),
            child: Row(
              children: [
                SizedBox(width: 12 * sizeUnit),
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

