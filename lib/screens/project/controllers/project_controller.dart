import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/util/global_function.dart';

class ProjectController extends GetxController {
  late final Project project;
  late final bool isIndex;
  bool isLoading = true;

  void initState({required Project? project, required bool isIndex}) async{
    if(project == null) {
      late final String? id;
      this.isIndex = isIndex;

      if(isIndex) {
        id = 'N1Z1RfyvMRfz52SP2K4g';
      } else {
        id = Get.parameters['id'];
      }

      // 잘못된 url 예외처리
      if(id == null) return GlobalFunction.goToBack();

      // 서버에서 프로젝트 불러오기
      Project? res = await ProjectRepository.getProjectByID(id);
      if(res != null) {
        this.project = res;
      } else {
        return GlobalFunction.goToBack(); // 잘못된 project 예외처리
      }
    } else {
      this.project = project;
    }

    isLoading = false;
    update();
  }
}