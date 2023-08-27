import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../model/category_color.dart';
import '../model/schedule.dart';
import 'package:path/path.dart' as p;

/* part keyword ? */
// import 는 private 값들을 불러올 수 없으나, part 는 가능
part 'drift_database.g.dart';   /* g 붙이는 이유? 자동으로 생성시킨다는 의미 */

/* flutter pub add --dev drift_dev 하고나서 됐음 */

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ]
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  /* Schedule Table CREATE */
  /* insert 한 값의 PRIMARY KEY return */
  Future<int> createSchedule(SchedulesCompanion data /* 우리가 만든 Schedules class + Companion */
      ) => into(schedules /* Table */).insert(data);

  /* CategoryColor Table CREATE */
  Future<int> createCategoryColor(CategoryColorsCompanion data
      ) => into(categoryColors).insert(data);

  /* SELECT */
  Future<List<CategoryColor>> getCategoryColors(
      ) => select(categoryColors).get();

  /* Database 의 version 임! */
  /* Database 의 구조가 바뀔때(Table 구조 등) 버전업 */
  @override
  int get schemaVersion => 1;
}

// _$LocalDatabase class 는 앱 실행 시, 'drift_database.g.dart' 파일이 자동 생성되고
// 그 안에 위치 해있다. _는 private -> 그런데 불러올 수 있는 이유는 part 이기 떄문
// DriftDatabase 에서 불러올 model 을 불러와야 한다.

LazyDatabase _openConnection() {
  /* 보조기억장치(HDD) 어디에 저장할지 정해야함. */
  return LazyDatabase(() async {
    /* Scope Storage root directory */
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite' /* root 에 파일 생성 */ )); /* dart.io */
    return NativeDatabase(file);
  });

}