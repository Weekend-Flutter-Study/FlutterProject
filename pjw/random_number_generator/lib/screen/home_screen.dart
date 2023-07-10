import 'package:flutter/material.dart';
import 'package:random_number_generator/constant/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Row(
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: RED_COLOR,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [123, 456, 789]
                      .map(
                        (e) => Row(
                          children: e
                              .toString()
                              .split('')
                              .map((e) => Image.asset(
                                    'asset/img/$e.png',
                                    height: 70.0,
                                    width: 50.0,
                                  ))
                              .toList(),
                        ),
                      ).toList(),
                ),
              ),
              // Container 로 사용해도 괜찮지만, 정확히 어떤 View 인지 명확한게 SizedBox
              // Container(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       onPressed: () {},
              //       child: Text('생성하기')
              //   ),
              // )
              SizedBox(
                width: double.infinity, // 양 끝까지 채우는 방법
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 활성화 되어있을 때의 색상
                      primary: RED_COLOR,
                    ),
                    onPressed: () {},
                    child: Text('생성하기')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
