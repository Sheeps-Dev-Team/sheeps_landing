import 'dart:convert';
import 'dart:html';

import 'package:bootpay/bootpay.dart';
import 'package:bootpay/config/bootpay_config.dart';
import 'package:bootpay/model/browser_open_type.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sheeps_landing/config/constants.dart';
import 'package:sheeps_landing/data/global_data.dart';
import 'package:sheeps_landing/data/models/project.dart';
import 'package:sheeps_landing/repository/project_repository.dart';
import 'package:sheeps_landing/util/global_function.dart';

import '../../config/routes.dart';
import '../../util/components/responsive.dart';

class ProjectDashboardPage extends StatefulWidget {
  const ProjectDashboardPage({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDashboardPage> createState() => _ProjectDashboardPageState();
}

class _ProjectDashboardPageState extends State<ProjectDashboardPage> {

  Payload payload = Payload();
  //
  String webApplicationId = '6551aadd00be04001d957044';
  String androidApplicationId = '6551aadd00be04001d957045';
  String iosApplicationId = '6551aadd00be04001d957046';

  String get applicationId {
    return Bootpay().applicationId(
        webApplicationId,
        androidApplicationId,
        iosApplicationId
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bootpayAnalyticsUserTrace(); //통계용 함수 호출
    bootpayAnalyticsPageTrace(); //통계용 함수 호출
    bootpayReqeustDataInit(); //결제용 데이터 init
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: $style.colors.lightGrey,
      body: Padding(
        padding: isDesktop ? EdgeInsets.all($style.insets.$40) : EdgeInsets.all($style.insets.$16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '대시보드',
                style: isDesktop ? $style.text.headline32 : $style.text.headline20,
              ),
              Text(
                '프로젝트 정보 확인 및 수정이 가능합니다.',
                style: isDesktop ? $style.text.body16 : $style.text.body12,
              ),
              Gap(isDesktop ? $style.insets.$24 : $style.insets.$12),
              contentsArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '프로젝트 정보',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 2 * sizeUnit,
                      color: $style.colors.lightGrey,
                    ),
                    Gap($style.insets.$12),
                    dashboardWidget(
                      '프로젝트 이름',
                      widget.project.name,
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        dashboardWidget(
                          '프로젝트 URL',
                          widget.project.getUrl,
                          isDesktop,
                          () {
                            //Get.toNamed('${Routes.project}/${widget.project.documentID}', arguments: widget.project);
                            window.open(widget.project.getUrl, widget.project.name);
                          },
                        ),
                        const Gap(12),
                        InkWell(
                          onTap: () {
                            window.open(widget.project.getUrl, widget.project.name);
                          },
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.open_in_new_sharp,
                              color: $style.colors.darkGrey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      'Call To Action 타입',
                      widget.project.callbackType.split(division).first,
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      '조회 수',
                      widget.project.viewCount.toString(),
                      isDesktop,
                    ),
                    Gap($style.insets.$20),
                    dashboardWidget(
                      '좋아요 수',
                      widget.project.likeCount.toString(),
                      isDesktop,
                    ),
                  ],
                ),
              ),
              Gap($style.insets.$20),
              contentsArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '프로젝트 수정',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 2 * sizeUnit,
                      color: $style.colors.lightGrey,
                    ),
                    Gap($style.insets.$12),
                    Container(
                      width: 120 * sizeUnit,
                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.primary)),
                      child: TextButton(
                          onPressed: () => Get.toNamed(Routes.modifyProject, arguments: widget.project),
                          child: Text(
                            '프로젝트 수정',
                            style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                          )),
                    )
                  ],
                ),
              ),
              Gap($style.insets.$20),
            if(widget.project.orderID.isEmpty || widget.project.orderID == '') ... [
              contentsArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '990원으로 자신만의 랜딩 사이트를 소유하세요.',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 2 * sizeUnit,
                      color: $style.colors.lightGrey,
                    ),
                    Gap($style.insets.$12),
                    Row(children: [
                      const SizedBox(
                        child: Icon(
                          Icons.info_outlined,
                        ),
                      ),
                      Gap(8 * sizeUnit),
                      Text('구매를 진행하면 해당 ', style: $style.text.body16,),
                      TextButton(onPressed:() {
                        window.open('https://www.sheeps.kr/sheeps_landing/legal/terms','이용약관');
                      }, child: Text('이용약관', style: $style.text.body16.copyWith(color: $style.colors.blue),)),
                      Text('에 동의하며 ', style: $style.text.body16,),
                      TextButton(onPressed:() {
                        window.open('https://www.sheeps.kr/sheeps_landing/legal/privacy-policy','개인정보처리방침');
                      }, child: Text('개인정보처리방침', style: $style.text.body16.copyWith(color: $style.colors.blue),)),
                      Text('을 숙지하였음을 의미합니다', style: $style.text.body16,),
                    ],
                    ),
                    Row(
                      children: [
                        Text('990원 ', style: $style.text.body16.copyWith(color: $style.colors.blue),),
                        Text('결제시 페이지 내 하단 광고가 제거 되며, 결제한 금액은 14일 이내 환불 요청 시 100% 환불됩니다.', style: $style.text.body16,)
                      ],
                    ),
                    Gap($style.insets.$24),
                    Container(
                      width: 120 * sizeUnit,
                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular($style.corners.$32), border: Border.all(color: $style.colors.primary)),
                      child: TextButton(
                          onPressed: () {
                            goBootpayTest(context);
                          },
                          child: Text(
                            '결제하기',
                            style: $style.text.subTitle14.copyWith(color: $style.colors.primary),
                          )),
                    ),
                  ],
                ),
              ),
            ] else ... [
              contentsArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isDesktop ? 40 * sizeUnit : 30 * sizeUnit,
                      child: Text(
                        '결제 취소',
                        style: isDesktop ? $style.text.subTitle20 : $style.text.subTitle16,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 2 * sizeUnit,
                      color: $style.colors.lightGrey,
                    ),
                    Gap($style.insets.$12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const SizedBox(
                        child: Icon(
                          Icons.info_outlined,
                        ),
                      ),
                      Gap(8 * sizeUnit),
                      Text('결제한 금액은 14일 이내 환불 요청 시 100% 환불됩니다.\n구매 취소를 위해서는 카카오톡 채널로 직접 문의해 주시길 바랍니다.', style: $style.text.body16,)
                    ],
                    ),
                    Gap($style.insets.$24),
                    Container(
                      width: 120 * sizeUnit,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular($style.corners.$32),
                        border: Border.all(color: $style.colors.red),
                      ),
                      child: TextButton(
                          onPressed: () {
                            window.open('http://pf.kakao.com/_xjGxcbG/chat','문의하기');
                          },
                          child: Text(
                            '결제 취소',
                            style: $style.text.subTitle14.copyWith(color: $style.colors.red),
                          )),
                    ),
                  ],
                ),
              ),
            ]
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardWidget(String label, String contents, bool isDesktop, [GestureTapCallback? onTap]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: isDesktop ? $style.text.subTitle16 : $style.text.subTitle14,
        ),
        Gap($style.insets.$4),
        Container(
          padding: EdgeInsets.all($style.insets.$8),
          constraints: BoxConstraints(
            minWidth: 800 * sizeUnit,
            minHeight: isDesktop ? 44 * sizeUnit : 34 * sizeUnit,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular($style.corners.$4),
            border: Border.all(color: $style.colors.barrierColor),
          ),
          child: InkWell(
            onTap: onTap,
            child: Text(
              contents,
              style: isDesktop ? $style.text.subTitle18 : $style.text.body12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Container contentsArea({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all($style.insets.$16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular($style.corners.$8),
        border: Border.all(color: $style.colors.lightGrey),
      ),
      child: child,
    );
  }



  void bootpayAnalyticsUserTrace() async {

    await Bootpay().userTrace(
        id: 'user_1234',
        email: 'user1234@gmail.com',
        gender: -1,
        birth: '19941014',
        area: '서울',
        applicationId: applicationId
    );
  }

  void bootpayAnalyticsPageTrace() async {

    StatItem item1 = StatItem();
    item1.itemName = "랜딩페이지"; // 주문정보에 담길 상품명
    item1.unique = "ITEM_CODE_PAGE"; // 해당 상품의 고유 키
    item1.price = 990; // 상품의 가격
    item1.cat1 = '모바일';
    item1.cat2 = '상품';

    List<StatItem> items = [item1];

    await Bootpay().pageTrace(
        url: 'main_1234',
        pageType: 'sub_page_1234',
        applicationId: applicationId,
        userId: 'user_1234',
        items: items
    );
  }

  void bootpayReqeustDataInit() {
    Item item1 = Item();
    item1.name = "랜딩페이지"; // 주문정보에 담길 상품명
    item1.qty = 1;
    item1.price = 990; // 상품의 가격
    item1.id = "ITEM_CODE_RANDING_PAGE_BANNER"; // 해당 상품의 고유 키
    item1.cat1 = '모바일';
    item1.cat2 = '상품';

    List<Item> itemList = [item1];

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id

    payload.orderName = "랜딩페이지"; //결제할 상품명
    payload.price = 990; //정기결제시 0 혹은 주석


    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함


    payload.metadata = {
      "callbackParam1" : "value12",
      "callbackParam2" : "value34",
      "callbackParam3" : "value56",
      "callbackParam4" : "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    payload.items = itemList; // 상품정보 배열


    User user = User(); // 구매자 정보
    user.id = GlobalData.loginUser!.documentID;
    user.username = GlobalData.loginUser!.name;
    user.email = GlobalData.loginUser!.email;
    user.area = "null";
    user.phone = "010-0000-0000";
    user.addr = 'null';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutter';

    if(BootpayConfig.ENV == -1) {
      payload.extra?.redirectUrl = 'https://dev-api.bootpay.co.kr/v2';
    } else if(BootpayConfig.ENV == -2) {
      payload.extra?.redirectUrl = 'https://stage-api.bootpay.co.kr/v2';
    }  else {
      payload.extra?.redirectUrl = 'https://api.bootpay.co.kr/v2';
    }

    payload.user = user;
    payload.items = itemList;
    payload.extra = extra;
  }

  //버튼클릭시 부트페이 결제요청 실행
  void goBootpayTest(BuildContext context) {
    if(kIsWeb) {
      payload.extra?.openType = 'iframe';
    }
    payload.extra?.browserOpenType = [
      BrowserOpenType.fromJson({"browser": "kakao", "open_type": 'popup'}),
    ];

    payload.extra?.displayCashReceipt = false;

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
        if (kDebugMode) {
          print('------- onCancel 1 : $data');
        }
      },
      onError: (String data) {
        if (kDebugMode) {
          print('------- onError: $data');
        }
      },
      onClose: () {
        if (kDebugMode) {
          print('------- onClose');
        }
        Future.delayed(const Duration(seconds: 0)).then((value) {

          if (mounted) {
            if (kDebugMode) {
              print('Bootpay().dismiss');
            }
            Bootpay().dismiss(context);
          }
        });
      },
      onIssued: (String data) {
        if (kDebugMode) {
          print('------- onIssued: $data');
        }
      },
      onConfirm: (String data)  {
        if (kDebugMode) {
          print('------- onConfirm: $data');
        }
        Map<String, dynamic> jsonMap = jsonDecode(data);
        if (kDebugMode) {
          print(jsonMap['order_id']);
        }

        ProjectRepository.updateOrderID(documentID: widget.project.documentID, orderID: jsonMap['order_id']);

        widget.project.orderID = jsonMap['order_id'];
        widget.project.orderedAt = DateTime.now();

        GlobalFunction.showCustomDialog();

        Bootpay().dismiss(context);

        GlobalFunction.showCustomDialog(
          title: '결제 성공',
          description: '결제 해주셔서 정말 감사합니다.🙏\n보다 나은 서비스로 보답하겠습니다.🙇‍',
        ).then((value) {
          setState(() {

          });
        });

        return false;
      },
      onDone: (String data) {
        if (kDebugMode) {
          print('------- onDone: $data');
        }
      },
    );
  }
}
