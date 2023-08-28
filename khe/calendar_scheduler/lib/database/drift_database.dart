import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// part 키워드 : import 와 비슷하지만 넓은 기능.
// import는 private 값등은 불러 올 수 없다.
// part는 private 값까지 다 불러올 수 있다.

// 현재 파일 이름에 g 를 넣음 g 는 generated 됐다,
// 즉, 자동으로 생성이 됐다는 의미 -> 커맨드 하나 치면 drift_database.g.dart 파일이 생성 될 거임
part 'drift_database.g.dart';

// decorator ex) @override
// DriftDatabase decorator
@DriftDatabase(
  tables: [
    // 아래 2개의 테이블이 데이터 베이스 테이블로 인식 됨
    // 불러올 때 인스턴스 ex) Schedules() 처럼 불러오는게 아닌 타입 선언하듯이 ex) Schedules
    Schedules,
    CategoryColors,
  ]
)
class LocalDatabase extends _$LocalDatabase{
  // LocalDatabase를 _$ 한 뒤 extends 한다
  // _$LocalDatabase 클래스는 drift가 만들어 주고, 이 클래스가 있는 파일은 drift_database.g.dart가 된다.
  LocalDatabase() : super(_openConnection());

  //INSERT
  // SchedulesCompanion 안에다가 넣어줘야 정확히 insert 된
  // drift가 sql을 전환을 하는 방식
  // Future<int> 를 통해 primary key를 돌려 받을 수 있다.
  Future<int> createSchedule(SchedulesCompanion data) =>
      //schedules table에다가 값을 넣을거다
      into(schedules).insert(data);

  //색상 inseert
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  //categoryColor를 가져오는 기능
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 스케줄 추가 후 달력 리스트에 추가한 내용이 업데이트 되도록
  // Stream<List<Schedule>> watchSchedules()=>
  //     select(schedules).watch(); // watch: future대신 stream, get: 단발성 future 한번
  // 메모리 절약을 위해 아래와같이 바꾼다.
  Stream<List<Schedule>> watchSchedules(DateTime date){
    // final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();

    int number =3;
    // '3' -> String
    // : toString 실행해서 가져 올 수 있는 값이 리턴
    final resp = number.toString();
    // 3 -> int
    // : toString 실행이 된 그 대상이 리턴 됨
    final resp2 = number..toString();

    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  @override
  int get schemaVersion => 1; // data 베이스에 설정한 테이블들의 상태의 버전 // 데이터 베이스 구조 즉 테이블구조가 바뀔때 버전이 올라감
}

// 연결
LazyDatabase _openConnection(){
  // 실제 데이터 베이스 파일을 어떤 위치에 생성 시킬건지 설정
  // sql 은 보조기억장치(하드 드라이브)에 저장을 하는데, 연결을 해준다.
  return LazyDatabase(() async{
    // 특정 기기에 설치를 했을때 이 앱 전용으로 사용할 수 있는 폴더의 위치를 가져 올 수 있음
    // 폴더 위치에 데이터 베이스 정보를 저장하면 됨
    final dbFolder = await getApplicationDocumentsDirectory();
    // import 할때 io로 !
    final file = File(
      // 파일 생성하고 싶은 위치
      p.join(dbFolder.path, 'db.sqlite'),
    );
    // 파일을 통해 db 생성
    return NativeDatabase(file);

  });
}