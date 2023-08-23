import 'package:drift/drift.dart';

// 데이터 구조와 관련된 모든 것들을 model 에 넣을 예정.

// Schedules 테이블 안에다가 7개의 column
class Schedules extends Table { //Table은 drift를 통해 가져옴
  // IntColumn: drift에서 / getter / id : Column의 이름 / => 값을 return
  // return : integer()() 실행, 실행

  // id 는 PRIMARY KEY
  // primary key에는 autoIncrement : 1, 2, 3 ... 중복 x -> 직접 insert 필요 없고, 자동으로 1씩 증가..
  // 실력 up -> uuid
  IntColumn get id => integer().autoIncrement()();

  // 내용: content column 은 text
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성날짜 -> 항상 DateTime.now() 일거임
  DateTimeColumn get createdAt => dateTime().clientDefault(
      () => DateTime.now(),
  )();
}