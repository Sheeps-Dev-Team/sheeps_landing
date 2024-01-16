import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/screens/project/controllers/project_communication_controller.dart';
import 'package:sheeps_landing/util/components/custom_data_table.dart';

import '../../config/constants.dart';
import '../../util/components/responsive.dart';

class ProjectCommunicationPage extends StatelessWidget {
  ProjectCommunicationPage({super.key, required this.project});

  final ProjectCommunicationController controller = Get.put(ProjectCommunicationController());
  final Project project;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      body: Padding(
        padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '커뮤니케이션',
              style: isDesktop ? $style.text.headline32 : $style.text.headline20,
            ),
            Text(
              'Call To Action 데이터를 확인할 수 있습니다.',
              style: isDesktop ? $style.text.body16 : $style.text.body12,
            ),
            Gap(isDesktop ? $style.insets.$24 : $style.insets.$12),
            Expanded(
              child: contentsArea(
                isDesktop: isDesktop,
                child: GetBuilder<ProjectCommunicationController>(builder: (_) {
                  if (controller.isLoading) return const SizedBox.shrink();

                  return CustomDataTable(
                    columns: controller.communicationTableColumns,
                    rows: List.generate(
                      controller.userCallbackList.length,
                          (index) => [
                        (controller.userCallbackList.length - index).toString(),
                        controller.callbackTypes[index],
                        ...controller.userCallbackList[index].getRows,
                      ],
                    ),
                    widthFlexList: isDesktop ? [] : const [1, 1, 1, 2, 2, 2],
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


  Widget contentsArea({required Widget child, required bool isDesktop}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? $style.insets.$16 : $style.insets.$8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular($style.corners.$8),
        border: Border.all(color: $style.colors.lightGrey),
      ),
      child: child,
    );
  }
}
