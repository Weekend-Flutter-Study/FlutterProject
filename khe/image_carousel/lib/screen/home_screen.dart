import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageController 생성 :
  final PageController pageController = PageController();

  //initState() 함수 등록 : state가 생성될 때 딱 한번만 싱행 -> 앱 재 실행시에만 코드 실행
  @override
  void initState() {
    super.initState();

    Timer.periodic( // 특정 함수 주기적 실행 
      Duration(seconds: 3),
          (timer) {
        //현재 페이지 가져오기 : pageController.page의 게터를 사용하여 PageView의 현재 페이지 가져 올 수 있음
        // 페이지가 변경 중일 때 소수점 표현 -> double 값 반환 -> 실질적 정수 값 필요 -> toInt() 사용
        int? nextPage = pageController.page?.toInt();

        if(nextPage == null){ // 페이지 값이 없을 때 예외 처리
          return;
        }

        if(nextPage == 4) {  // 첫 페이지와 마지막 페이지 분기 처리
          nextPage = 0; // 페이지가 마지막일 경우 첫 페이지로
        } else {
          nextPage++;
        }

        pageController.animateToPage( // 페이지 변경
        nextPage, duration: Duration(microseconds: 500), curve: Curves.ease,
        );


        },
    );
  }

  @override
  Widget build(BuildContext context) {
    //상태바 흰색으로 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: PageView(
        controller: pageController, // pageController 등록
        children: [1, 2, 3, 4, 5]
            .map((number) =>
            Image.asset('asset/img/image_$number.jpg',
              fit: BoxFit.cover,
            ),
        ).toList(),
      ),
    );
  }
}
