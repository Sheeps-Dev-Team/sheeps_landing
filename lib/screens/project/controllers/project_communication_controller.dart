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
    '일시',
  ];

  //각 사용자 콜백의 콜백 타입을 저장하는 목록
  List<String> callbackTypes = [];

  //calltoback 데이터 받아오기
  @override
  void onInit() async {
    super.onInit();

    final String? id = Get.parameters['id'];

    //콜백 데이터 불러와서 뿌려주기
    if (id != null) {
      //콜백 데이터 저장 변수 res
      userCallbackList = await UserCallbackRepository.getUserCallbackListByProjectID(id);

      //이름, 이메일, 전화번호 중에 하나라도 선택되면 폼타입으로 확인
      callbackTypes = userCallbackList.map((userCallback) {
        if (userCallback.name != null || userCallback.email != null || userCallback.phoneNumber != null) {
          return UserCallback.typeForm;
        } else {
          return UserCallback.typeLink;
        }
      }).toList();

      isLoading = false;
      update();
    } else {
      GlobalFunction.goToBack();
    }
  }

}


