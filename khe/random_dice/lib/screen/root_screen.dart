import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  // TickerProviderStateMixin 사용하기

  TabController? tabController; // 사용할 TabController 선언
  double threshold = 2.7; // 민감도의 기본값 설정
  int number = 1; // 주사위 숫자
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this); // 컨트롤러 초기화 하기
    // tabController 에서 vsync 사용하려면 TickerProviderStateMixin(애니메이션 효율)을 사용해야 한다.
    tabController!
        .addListener(tabListener); // tab의 인덱스 값이 변경 될 때마다 특정 함수(tabListener) 실행

    shakeDetector = ShakeDetector.autoStart(
        // 코드가 실행되는 순간 부터 흔들기 감지 즉시 시작 autoStart 외에 waitForStart 존재
        shakeSlopTimeMS: 100, // 감지 주기, 밀리초 단위
        shakeThresholdGravity: threshold, // 감지 민감도 // settingScreen의 Slider 위젯에서 받아옴
        onPhoneShake: onPhoneShake // 감지 후 실행할 함수
        );
  }

  void onPhoneShake() { // 핸드폰을 흔들 때마다 난수 생성
    final rand = new Random();

    setState(() {
      // nextInt: 첫 번째 매개변수에 생성될 최대 int 값을 넣어주면 된다. 난수는 0부터 생성
      number = rand.nextInt(5) + 1; // 1 ~ 6
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController!.removeListener(tabListener);
    shakeDetector!.stopListening(); // 흔들기 감지 중지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController, // 컨트롤러 등록하기
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingsScreen(
        threshold: threshold,
        onThresholdChange: onThresholdChange,
      )
    ];
  }
 // 슬라이더값 변경 시 실행 함수
  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: tabController!.index,
      onTap: (int index) {
        // 탭이 선택될 때마다 실행되는 함수
        setState(() {
          tabController!.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.edgesensor_high_outlined),
          label: '주사위',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '설정',
        ),
      ],
    );
  }
}
