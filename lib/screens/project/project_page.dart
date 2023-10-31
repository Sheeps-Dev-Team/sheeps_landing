import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/screens/project/controllers/project_controller.dart';
import 'package:sheeps_landing/screens/template/default_template.dart';
import 'package:sheeps_landing/util/components/base_widget.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({super.key, this.project, this.isIndex = false});

  final Project? project;
  final bool isIndex;

  final ProjectController controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        body: GetBuilder<ProjectController>(
          initState: (state) => controller.initState(project: project, isIndex: isIndex),
          builder: (_) {
            if (controller.isLoading) return Center(child: CircularProgressIndicator(color: $style.colors.primary));

            switch (controller.project.templateID) {
              case DefaultTemplate.id:
                return DefaultTemplate(
                  project: controller.project,
                  isIndex: isIndex,
                );
              default:
                return DefaultTemplate(
                  project: controller.project,
                  isIndex: isIndex,
                );
            }
          },
        ),
      ),
    );
  }
}
