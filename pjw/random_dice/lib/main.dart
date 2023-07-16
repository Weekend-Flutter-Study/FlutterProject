import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';
import 'package:random_dice/screen/root_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        sliderTheme: SliderThemeData(
          thumbColor: primayColor, // 노브 색상
          activeTrackColor: primayColor, // 노브가 이동한 트랙 색상,

          // 노브가 아직 이동하지 않은 트랙 색상
          inactiveTrackColor: primayColor.withOpacity(0.3),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primayColor, // 선택 상태 색
          unselectedItemColor: secondaryColor, // 비선택 상태 색
          backgroundColor: backgroundColor,
        )
      ),
      debugShowCheckedModeBanner: false,
      home: RootScreen(),
    ),
  );
}
