import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/screens/project/controllers/project_management_controller.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';

import '../../config/constants.dart';
import '../../util/components/responsive.dart';

class ProjectManagementPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProjectManagementPage({super.key});

  final ProjectManagementController controller = Get.put(ProjectManagementController());

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
                child: GetBuilder<ProjectManagementController>(builder: (_) {
                  return sideMenu(isDesktop);
                }),
              ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GetBuilder<ProjectManagementController>(builder: (_) {
            return Row(
              children: [
                if (isDesktop) ...{
                  sideMenu(isDesktop),
                },
                Expanded(
                  child: controller.page,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  //사이드바
  Container sideMenu(bool isDesktop) {
    return Container(
      margin: EdgeInsets.only(top: $style.insets.$8),
      width: 240 * sizeUnit,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(controller.pageMap.length, (index) {
          final String key = controller.pageMap.keys.toList()[index];

          return menuListItem(
            key,
            onPressedFunc: () {
              controller.onChangedPageKey(key);
            },
            isDesktop: isDesktop,
          );
        }),
      ),
    );
  }

  //사이드바 메뉴
  Widget menuListItem(String text, {required Function onPressedFunc, required bool isDesktop}) {
    final bool isSelected = controller.pageKey == text; // 현재 항목의 선택 상태 확인

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: isDesktop ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : EdgeInsets.symmetric(horizontal: $style.insets.$10),
            child: InkWell(
              highlightColor: $style.colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular($style.corners.$12)),
              onTap: () {
                onPressedFunc();
              },
              hoverColor: const Color.fromRGBO(243, 237, 246, 0.5),
              child: Container(
                width: double.infinity,
                height: 32 * sizeUnit,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: $style.insets.$16),
                decoration: BoxDecoration(
                  color: isSelected ? $style.colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular($style.corners.$12),
                  border: Border.all(color: $style.colors.primary),
                ),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: $style.text.body14.copyWith(color: isSelected ? Colors.white : $style.colors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap($style.insets.$12),
        ],
      ),
    );
  }
}
