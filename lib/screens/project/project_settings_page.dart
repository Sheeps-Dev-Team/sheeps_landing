import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';

import '../../config/constants.dart';

class ProjectSettingsPage extends StatelessWidget {
  const ProjectSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: $style.colors.lightGrey,
        padding: EdgeInsets.all($style.insets.$40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '프로젝트 설정',
              style: $style.text.headline32,
            ),
            Text(
              '프로젝트 삭제가 가능합니다.',
              style: $style.text.body16,
            ),
            Gap($style.insets.$24),
            contentsArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40 * sizeUnit,
                    child: Text(
                      '프로젝트 삭제',
                      style: $style.text.subTitle20,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                  Gap($style.insets.$12),
                  Container(
                    width: 120 * sizeUnit,
                    //height: 28 * sizeUnit,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular($style.corners.$32),
                        border: Border.all(color: $style.colors.red)
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all($style.colors.red.withOpacity(0.1)),
                      ),
                        onPressed: () {},
                        child: Text('프로젝트 삭제', style: $style.text.subTitle14.copyWith(color: $style.colors.red),)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Container contentsArea({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all($style.insets.$16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular($style.corners.$8),
        border: Border.all(color: $style.colors.lightGrey),
      ),
      child: child,
    );
  }

}
