import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/repository/user_repository.dart';
import 'package:sheeps_landing/util/components/custom_text_field.dart';
import 'package:sheeps_landing/util/components/site_app_bar.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/constants.dart';
import '../../util/components/responsive.dart';

class UserClosePage extends StatefulWidget {
  const UserClosePage({super.key});

  @override
  State<UserClosePage> createState() => _UserClosePageState();
}

class _UserClosePageState extends State<UserClosePage> {
  List<String> reasonList = ['모든 사이트를 비활성화하고 싶습니다.', '더 이상 사이트가 필요 없습니다.', '기타 문제입니다.'];

  TextEditingController textEditingController = TextEditingController();
  bool isCheck = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      appBar: SiteAppBar(
        centerTitle: isDesktop ? false : true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.chevron_left, color: $style.colors.darkGrey,),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap($style.insets.$12),
              Text(
                '계정 설정   >   Sheeps Landing 계정 닫기',
                style: isDesktop ? $style.text.body16 : $style.text.body10,
              ),
              Gap($style.insets.$8),
              Text(
                'Sheeps Landing 계정 폐쇄',
                style: isDesktop ? $style.text.headline32 : $style.text.headline20,
              ),
              Gap($style.insets.$8),
              Text(
                'Sheeps Landing 계정을 폐쇄하면 모든 데이터가 삭제됩니다.',
                style: isDesktop ? $style.text.subTitle18 : $style.text.body12,
              ),
              Gap($style.insets.$24),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all($style.insets.$16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular($style.corners.$8),
                  border: Border.all(color: $style.colors.lightGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '계정을 폐쇄하려는 이유를 알려주세요. (선택사항)',
                      style: isDesktop ? $style.text.body16 : $style.text.body14,
                    ),
                    Gap($style.insets.$8),
                    SizedBox(
                      width: 600 * sizeUnit,
                      height: 48 * sizeUnit,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular($style.corners.$8),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: $style.colors.primary, width: 1 * sizeUnit),
                              borderRadius: BorderRadius.circular($style.corners.$8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: $style.colors.primary, width: 1 * sizeUnit),
                              borderRadius: BorderRadius.circular($style.corners.$8),
                            )),
                        hint: Text(
                          '이유를 선택해주세요.',
                          style: $style.text.body14.copyWith(color: $style.colors.grey),
                        ),
                        items: reasonList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: $style.text.body14.copyWith(color: $style.colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (kDebugMode) debugPrint(value!);
                        },
                      ),
                    ),
                    Gap($style.insets.$40),
                    Text(
                      '여러분의 피드백은 소중합니다.\n추가로 공유할 내용이 있으신가요? (선택사항)',
                      style: isDesktop ? $style.text.body16 : $style.text.body14,
                    ),
                    Gap($style.insets.$8),
                    CustomTextField(
                      controller: textEditingController,
                      width: 600 * sizeUnit,
                      focusBorderColor: $style.colors.primary,
                      cursorColor: $style.colors.primary,
                      maxLines: 5,
                      minLines: 5,
                      maxLength: 500,
                      onChanged: (p0) {},
                    ),
                    Gap(isDesktop ? $style.insets.$32 : $style.insets.$16),
                    accountCloseWidget(isDesktop: isDesktop),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 체크박스 옆 텍스트 위젯
  Column accountCloseWidget({required bool isDesktop}) {
    String text = '계정을 탈퇴하면 모든 데이터가 삭제된다는 것을 인지하고 있습니다.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            customCheckbox(),
            Gap($style.insets.$8),
            if (isDesktop) ...{
              GestureDetector(
                child: Text(
                  text,
                  style: isDesktop ? $style.text.body16 : $style.text.body14,
                ),
                onTap: () {
                  setState(() {
                    isCheck = !isCheck;
                  });
                },
              ),
            } else if (!isDesktop) ...{
              Flexible(
                child: Text(
                  text,
                  style: isDesktop ? $style.text.body16 : $style.text.body14,
                ),
              ),
            },
          ],
        ),
        checkedText(isDesktop: isDesktop),
      ],
    );
  }

  //체크박스 체크 시 하단에 경고문구 위젯
  Widget checkedText({required bool isDesktop}) {
    String text = '현재 Sheeps Landing 계정 ${GlobalData.loginUser!.email}을 영구히 폐쇄합니다.\n폐쇄 계정은 다시 복구할 수 없으며, 관련 데이터는 모두 유실됩니다.';
    if (isDesktop) {
      return Row(
        children: [
          if (isCheck) ...[
            Gap($style.insets.$4),
            Text(
              text,
              style: $style.text.subTitle14.copyWith(color: $style.colors.red),
            ),
          ],
          const Spacer(),
          accountCloseBtn(),
        ],
      );
    } else if (!isDesktop) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCheck) ...[
            Text(
              text,
              style: $style.text.subTitle14.copyWith(color: $style.colors.red),
            ),
          ],
          Gap($style.insets.$8),
          Align(
            alignment: Alignment.centerRight,
            child: accountCloseBtn(),
          ),
        ],
      );
    }
    return Container();
  }

  //계정 닫기 버튼
  Container accountCloseBtn() {
    return Container(
      width: 90 * sizeUnit,
      height: 28 * sizeUnit,
      decoration: BoxDecoration(
        color: isCheck == false ? Colors.transparent : $style.colors.red,
        borderRadius: BorderRadius.circular($style.corners.$32),
        border: Border.all(color: $style.colors.red),
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all($style.colors.red.withOpacity(0.1)),
        ),
        onPressed: () async {
          if (isCheck) {
            if (await UserRepository.setUserClose()) {
              GlobalFunction.logout();
            }
          }
        },
        child: Text(
          '계정 닫기',
          style: $style.text.subTitle14.copyWith(color: isCheck == false ? $style.colors.red : Colors.white),
        ),
      ),
    );
  }

  //체크박스
  Checkbox customCheckbox() {
    return Checkbox(
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
        borderRadius: BorderRadius.circular($style.corners.$4),
      ),

      /// 체크박스를 클릭했을 때 호출
      onChanged: (value) {
        setState(() {
          isCheck = !isCheck;
        });
      },
    );
  }
}
