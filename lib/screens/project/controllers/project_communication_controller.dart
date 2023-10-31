import 'package:get/get.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';

class ProjectCommunicationController extends GetxController {

  late final UserCallback userCallback;

  final List<String> communicationTableColumns = [
    'No.',
    '타입',
    '이름',
    '이메일',
    '전화번호',
    'IP',
  ];

  /*final userCallback = UserCallback(
    documentID: '',
    projectID: 'projectID',
    ip: '',
    phoneNumber: '',
    email: '',
    name: '',
  );*/


}
