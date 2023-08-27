import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  //빨강
  'F44336',
  //주황
  'FF9800',
  //노랑
  'FFEB3B',
  //초록
  'FCAF50',
  //파랑
  '2196F3',
  //남색
  '3F51B5',
  //보라
  '9C27B0',
];

void main() async {
  //runApp 전에 다른 flutter code 실행하면, flutter framework가 준비 된 상태인지 확인 runApp에 확인하나, 그 전에 확인하려면 WidgetsFlutterBinding.ensureInitialized 작성 해줘야 함.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); //intl package에 있는 모든 언어를 사용 할 수 있게 됨.

  //database 불러오기
  final database = LocalDatabase();

  //중복체크를 위해 색상을 가져와서, 비어있으면 for문으로 넣어주기
  final colors = await database.getCategoryColors();

  if(colors.isEmpty){
    // print('실행');
    for(String hexCode in DEFAULT_COLORS){
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  // print('--------GET COLORS ---------');
  // print(await database.getCategoryColors());

  runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        home: HomeScreen(),
      )
  );
}