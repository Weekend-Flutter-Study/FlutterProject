import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 80.0,
            fontWeight: FontWeight.w700,
            fontFamily: 'parisienne',
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
            fontWeight: FontWeight.w700,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 30.0
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          )
        )
      ),
      home: HomeScreen(),
    )
  );
}

// setState()
// state를 상속하는 모든 클래스는 setState() 사용 가능
// 1. 클린 상태 -> setState() -> 더티 상태 -> build () -> 클린 상태
// 클린상태에서 상태를 변경 해 주자

// setState() 함수는 매개변수 하나를 입력 받고, 이 매개변수는 콜백 함수이다.
// 이 콜백 함수(비동기 x)에 변경하고 싶은 속성들을 입력해주면 해당 코드가 반영된 뒤 build() 함수 실행
// ex) setState((){ // 실행
//  number ++;
// }