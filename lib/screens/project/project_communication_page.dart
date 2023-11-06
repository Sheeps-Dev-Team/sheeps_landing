import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/screens/project/controllers/project_communication_controller.dart';
import 'package:sheeps_landing/util/components/custom_data_table.dart';

import '../../config/constants.dart';

class ProjectCommunicationPage extends StatelessWidget {
  ProjectCommunicationPage({super.key, required this.project});

  final ProjectCommunicationController controller = Get.put(ProjectCommunicationController());
  final Project project;

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
                '커뮤니케이션',
                style: $style.text.headline32,
              ),
              Text(
                'Call To Action 데이터를 확인할 수 있습니다.',
                style: $style.text.body16,
              ),
              Gap(24 * sizeUnit),
              Expanded(
                child: contentsArea(
                  child: GetBuilder<ProjectCommunicationController>(builder: (_) {
                    if (controller.isLoading) return Container();

                    return CustomDataTable(
                      columns: controller.communicationTableColumns,
                      rows: List.generate(
                        controller.userCallbackList.length,
                        (index) => [
                          (index + 1).toString(),
                          controller.callbackTypes[index],
                          ...controller.userCallbackList[index].getRows,
                        ],
                      ),
                      onRowTap: (index) {},
                    );
                  }),
                ),
              ),
            ],
          ),
      ),
    );
  }


  Widget contentsArea({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
