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
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState(); // ➌ 부모 initState() 실행

    timer = Timer.periodic(
      // ➍ Timer.periodic() 등록
      const Duration(seconds: 4),
          (timer) {
        int currentPage = controller.page!.toInt();
        int nextPage = currentPage + 1;

        // ➌
        if (nextPage > 4) { // 마지막 페이지인 상황에서 5초가 지나 넘어갔을 때 첫번째 페이지로 넘어감
          nextPage = 0;
        }

        controller.animateToPage(
          // ➍ 페이지 변경
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose(); // controller 해제

    if (timer != null) {
      timer!.cancel(); // timer 해제
    }
    // super.dispose() 후에는 위젯이 사라지기 때문에
    // super.dispose() 위에 작업해준다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 상태바 색 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: PageView(
        controller: controller,
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