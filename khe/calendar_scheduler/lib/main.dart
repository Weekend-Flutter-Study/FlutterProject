import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  //runApp 전에 다른 flutter code 실행하면, flutter framework가 준비 된 상태인지 확인 runApp에 확인하나, 그 전에 확인하려면 WidgetsFlutterBinding.ensureInitialized 작성 해줘야 함.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); //intl package에 있는 모든 언어를 사용 할 수 있게 됨.

  runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        home: HomeScreen(),
      )
  );
}