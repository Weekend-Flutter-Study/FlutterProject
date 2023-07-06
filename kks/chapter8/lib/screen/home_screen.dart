import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ❷ State 정의
class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState(); // ➌ 부모 initState() 실행

    Timer.periodic(
      // ➍ Timer.periodic() 등록
      const Duration(seconds: 3),
          (timer) {
        print('실행!');
        int? nextPage = pageController.page?.toInt();

        // ➋
        if (nextPage == null) {
          return;
        }
        // ➌
        if (nextPage == 4) { // 마지막 페이지인 상황에서 넘겼을 때 첫번째 페이지로 넘어감
          nextPage = 0;
        } else {
          nextPage++;
        }
        pageController.animateToPage(
          // ➍ 페이지 변경
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView(
        controller: pageController,
        // ➊ PageView 추가
        children: [1, 2, 3, 4, 5] // ➋ 샘플 리스트 생성
            .map(
          // ➌ 위젯으로 매핑
              (number) => Image.asset(
            'asset/img/image_$number.jpeg',
            fit: BoxFit.cover,
          ),
        )
            .toList(),
      ),
    );
  }
}