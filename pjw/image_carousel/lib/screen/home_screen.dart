import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Future.delay 와 비슷하다.
  Timer? timer;

  // controller 도 dispose 해줘야한다.
  // autoDispose가 안댐?
  PageController controller = PageController(
    // 몇번째부터 시작할래?
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    // Hot reload 로는 작동 안댐! (initState 는 처음에만 불리니까)
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      // 왜 page가 double?
      // 넘어가는 중간은 0.5 이런식으로 댐
      int currentPage = controller.page!.toInt();
      int nextPage = currentPage + 1;

      if (nextPage > 4) {
        nextPage = 0;
      }

      controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          // 똑같은 속도로 움직임 = linear
          curve: Curves.linear,
      );
    });
  }

  // 위젯 사라질떄 타이머 안죽이며 메모리 leak
  // 생명주기의 마지막
  @override
  void dispose() {
    controller.dispose();
    // null check 해줬는데도 또 뜸 ..
    if(timer != null) {
      timer?.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // App bar 색상 (wifi , 시간 같은거)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView(
        // pageview 는 controller 직접 생성해야함
        controller: controller,
        children: [1, 2, 3, 4, 5].map(
                (e) => Image.asset(
                  'asset/img/image_$e.jpeg',
                  fit: BoxFit.cover,
                ),
        ).toList(),
        // children: [
        //   // Widget 을 복수로 받을 수 있음
        //
        //   // cover 전체화면에 맞춰 늘리기 (옆 위아래 짤릴 수도 있다)
        //   Image.asset('asset/img/image_1.jpeg', fit: BoxFit.cover,),
        //   Image.asset('asset/img/image_2.jpeg', fit: BoxFit.cover,),
        //   Image.asset('asset/img/image_3.jpeg', fit: BoxFit.cover,),
        //   Image.asset('asset/img/image_4.jpeg', fit: BoxFit.cover,),
        //   Image.asset('asset/img/image_5.jpeg', fit: BoxFit.cover,)
        // ],
      ),
    );
  }
}
