import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_number_generator/constant/color.dart';
import 'package:random_number_generator/screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> randomNumbers = [123, 456, 789];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          // Padding Option
          // zero : 패딩 적용 안하겠다! (왜있음?)
          // all : 전체적으로 적용
          // fromLTRB : 방향별 부분적용
          // only : top : ~~ 이렇게 param 으로 적용 가능
          // symetric : 좌우, 위아래로 줄 수 있음
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            // Axis 기본 Center
            crossAxisAlignment: CrossAxisAlignment.start, // start 정렬
            children: [
              _Header(),
              _Body(randomNumbers: randomNumbers),
              _Footer(onPressed: onRandomNumberGenerate)
            ],
          ),
        ),
      ),
    );
  }

  void onRandomNumberGenerate() {
    final random = Random();

    // final List<int> newNumbers = [];
    //
    // for (int i = 0; i < 3; i++) {
    //   final number = random.nextInt(1000);
    //   newNumbers.add(number);
    // }

    // 중복값 없앨 수 있는 set
    final Set<int> newNumbers = {};
    while (newNumbers.length != 3) {
      final number = random.nextInt(1000);
      newNumbers.add(number);
    }

    setState(() {
      randomNumbers = newNumbers.toList();
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '랜덤 숫자 생성기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          onPressed: () {
            // 스크린 이동 Navigtor
            // Widget Tree 에서 가장 가까운 Navigator 를 가져다줌
            // push는 Router Stack 에 넣기 위한 함수
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SettingsScreen();
                },
              ),
            );
          },
          icon: Icon(
            Icons.settings,
            color: RED_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<int> randomNumbers;

  const _Body({required this.randomNumbers, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: randomNumbers
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(bottom: e.key == 2 ? 0 : 16.0),
                child: Row(
                  children: e.value
                      .toString()
                      .split('')
                      .map((e) => Image.asset(
                            'asset/img/$e.png',
                            height: 70.0,
                            width: 50.0,
                          ))
                      .toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
    // Container 로 사용해도 괜찮지만, 정확히 어떤 View 인지 명확한게 SizedBox
    // Container(
    //   width: double.infinity,
    //   child: ElevatedButton(
    //       onPressed: () {},
    //       child: Text('생성하기')
    //   ),
    // );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 양 끝까지 채우는 방법
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // 활성화 되어있을 때의 색상
            primary: RED_COLOR,
          ),
          onPressed: onPressed,
          child: Text('생성하기')),
    );
  }
}
