import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

const DEFAULT_COLORS = [
  'F44336',
  'FF9800',
  'FCAF50',
  'FCAF50',
  '2196F3',
  '3F51B5',
  '9C27B0',
];


void main() async {
  //runApp 전에 다른 flutter code 실행하면, flutter framework가 준비 된 상태인지 확인 runApp에 확인하나, 그 전에 확인하려면 WidgetsFlutterBinding.ensureInitialized 작성 해줘야 함.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); //intl package에 있는 모든 언어를 사용 할 수 있게 됨.

  final database = LocalDatabase();

  /* 색이 들어가있나 확인하기 */
  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for(String hexcode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          /* id = autoInc : 굳이 넣을 필요 없다! */
          hexCode: Value(hexcode) /* 값을 넣을때 꼭 Value 써야함 */
        )
      );
    }
  }

  runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        home: HomeScreen(),
      )
  );
}