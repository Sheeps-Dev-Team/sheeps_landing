import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sheeps_landing/config/constants.dart';

class ProjectDashboardPage extends StatelessWidget {
  const ProjectDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('프로젝트 이름 : test', style: $style.text.subTitle18,),
              Gap($style.insets.$20),
              editBtn(),
            ],
          ),
          Row(
            children: [
              Text('프로젝트 URL : www.test.co.kr', style: $style.text.subTitle18,),
              Gap($style.insets.$20),
              editBtn(),
            ],
          ),
          Text('유입 수 : 10'),
          Text('UserCallBack 타입'),
        ],
      )
    );
  }

  InkWell editBtn() {
    return InkWell(
              child: Text('수정', style: $style.text.body14,),
              onTap: (){},
            );
  }

}