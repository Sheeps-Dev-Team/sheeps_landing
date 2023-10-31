import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';
import 'package:sheeps_landing/screens/project/controllers/project_communication_controller.dart';
import 'package:sheeps_landing/util/components/custom_data_table.dart';

import '../../config/constants.dart';

class ProjectCommunicationPage extends StatelessWidget {
  ProjectCommunicationPage({super.key, required this.userCallback});

  final ProjectCommunicationController controller = Get.put(ProjectCommunicationController());
  final UserCallback userCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all($style.insets.$20),
        padding: EdgeInsets.all($style.insets.$30),
        decoration: BoxDecoration(
          boxShadow: $style.boxShadows.bs1,
          color: Colors.white,
          border: Border.all(color: $style.colors.primary),
          borderRadius: BorderRadius.circular($style.corners.$12),
        ),
        child: CustomDataTable(
          columns: controller.communicationTableColumns,
          rows: List.generate(
            10,
            (index) => [(index + 1).toString(), ...userCallback.getRows],
          ),
          onRowTap: (index) {},
        ),
      ),
    );
  }
}
