import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';

import '../../../repository/user_callback_repository.dart';
import '../../../util/global_function.dart';

class ProjectCommunicationController extends GetxController {

  late final List<UserCallback> userCallbackList;
  bool isLoading = true; //데이터 로딩 중 여부 체크 변수 - 로딩 중인 상태

  final List<String> communicationTableColumns = [
    'No.',
    '타입',
    '이름',
    '이메일',
    '전화번호',
    'IP',
  ];
  
  //calltoback 데이터 받아오기
  @override
  void onInit() async{
    super.onInit();

    final String? id = Get.parameters['id'];

    if(id != null) {
      //콜백 데이터 저장 변수 res
      userCallbackList = await UserCallbackRepository.getUserCallbackListByProjectID(id);

      isLoading = false;
      update();
    } else {
      GlobalFunction.goToBack();
    }

  }


}


