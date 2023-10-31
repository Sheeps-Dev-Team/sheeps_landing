import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/screens/project/controllers/project_communication_controller.dart';
import 'package:sheeps_landing/util/components/custom_button.dart';
import 'package:sheeps_landing/util/components/custom_data_table.dart';

import '../../config/constants.dart';

class ProjectSettingsPage extends StatelessWidget {
  ProjectSettingsPage({super.key});

  final ProjectCommunicationController controller = Get.put(ProjectCommunicationController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all($style.insets.$20),
        padding: EdgeInsets.all($style.insets.$30),
        decoration: BoxDecoration(
          boxShadow: $style.boxShadows.bs1,
          color: Colors.white,
          border: Border.all(color: $style.colors.primary),
          borderRadius: BorderRadius.circular($style.corners.$12),
        ),
        child: Column(
          children: [
            CustomButton(
              width: 300 * sizeUnit,
              customButtonStyle: CustomButtonStyle.outline48,
              text: '프로젝트 삭제하기',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
