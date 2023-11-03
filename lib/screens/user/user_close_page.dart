import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/repository/user_repository.dart';
import 'package:sheeps_landing/screens/login/login_page.dart';
import 'package:sheeps_landing/util/components/custom_text_field.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';

import '../../config/constants.dart';

class UserClosePage extends StatefulWidget {
  UserClosePage({super.key});

  @override
  State<UserClosePage> createState() => _UserClosePageState();
}

class _UserClosePageState extends State<UserClosePage> {
  List<String> reasonList = ['모든 사이트를 비활성화하고 싶습니다.',
      '더 이상 사이트가 필요 없습니다.',
      '기타 문제입니다'];

  TextEditingController textEditingController = TextEditingController();
  bool isCheck = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: $style.colors.lightGrey,
        padding: EdgeInsets.all(40 * sizeUnit),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(12 * sizeUnit),
            Text('계정 설정   >   Sheeps Landing 계정 닫기', style: $style.text.body16,),
            Gap(8 * sizeUnit),
            Text('Sheeps Landing 계정 폐쇄',style: $style.text.headline32,),
            Gap(8 * sizeUnit),
            Text('Sheeps Landing 계정을 폐쇄하면 모든 데이터가 삭제됩니다.',style: $style.text.subTitle18),
            Gap(24 * sizeUnit),
            Container(
              width: double.infinity,
              height: 440 * sizeUnit,
              padding: EdgeInsets.all(24 * sizeUnit),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8 * sizeUnit),
                  border: Border.all(color: $style.colors.lightGrey)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('계정을 폐쇄하려는 이유를 알려주세요. (선택사항)', style: $style.text.body16.copyWith(fontWeight: FontWeight.w100),),
                  Gap(8 * sizeUnit),
                  SizedBox(
                    width: 600 * sizeUnit,
                    height: 48,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder:
                          OutlineInputBorder(
                            borderSide: BorderSide(color: $style.colors.primary, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: $style.colors.primary, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                      hint: Text('이유를 선택해주세요.', style: $style.text.body14.copyWith(color: $style.colors.grey),),
                      items: reasonList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e,style: $style.text.body14.copyWith(color: $style.colors.black),),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if(kDebugMode) debugPrint(value!);
                      },
                    ),
                  ),
                  Gap(40 * sizeUnit),
                  Text('여러분의 피드백은 소중합니다.\n추가로 공유할 내용이 있으신가요? (선택사항)', style: $style.text.body16.copyWith(fontWeight: FontWeight.w100),),
                  Gap(8 * sizeUnit),
                  CustomTextField(
                    controller: textEditingController,
                    width: 600 * sizeUnit,
                    autofocus: true,
                    focusBorderColor: $style.colors.primary,
                    cursorColor: $style.colors.primary,
                    maxLines: 2,
                    minLines: 2,
                    maxLength: 500,
                    onChanged: (p0) {
                    },
                  ),
                  Gap(32 * sizeUnit),
                  Row(
                    children: [
                          Checkbox(

                            /// 체크박스 선택 값
                            value: isCheck,

                            /// 체크박스를 누르고 있을 때 발생하는 splash 이벤트의 컬러
                            overlayColor: MaterialStatePropertyAll(Colors.green.withOpacity(0.2)),

                            /// splash의 크기
                            splashRadius: 0,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: $style.colors.primary,


                            /// 체크박스의 모양 변경
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4 * sizeUnit),
                            ),

                            /// 체크박스를 클릭했을 때 호출
                            onChanged: (value) {
                              setState(() {
                                isCheck = !isCheck;
                              });
                            },
                          ),
                      Gap(8 * sizeUnit),
                      Text('계정을 탈퇴하면 모든 데이터가 삭제된다는 것을 인지하고 있습니다.',style: $style.text.body16,),
                      const Spacer(),
                      Container(
                        width: 90 * sizeUnit,
                        height: 28 * sizeUnit,
                        decoration: BoxDecoration(
                            color: isCheck == false ? Colors.transparent : $style.colors.red,
                            borderRadius: BorderRadius.circular(32 * sizeUnit),
                            border: Border.all(color: $style.colors.red)
                        ),
                        child: TextButton(
                            onPressed: () async {
                              if(await UserRepository.setUserClose()){
                                Get.to(() => LoginPage());
                              }
                            }, child: Text('계정 닫기',style: $style.text.subTitle14.copyWith(color: isCheck == false ? $style.colors.red : Colors.white),)),
                      )
                    ],
                  ),
                  if(isCheck) ... [
                    Text('현재 Sheeps Landing 계정${GlobalData.loginUser!.email}을 영구히 폐쇠합니다.\n폐쇄 계정은 다시 복구할 수 없으며, 관련 데이터는 모두 유실됩니다.',style: $style.text.subTitle14.copyWith(color: Colors.red),)
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
