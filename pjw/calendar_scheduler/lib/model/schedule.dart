import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  /* get -> getter */

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 종료 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성 날짜
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

/* Column 의 특수한 기능들? */
// autoIncrement - 자동으로 1씩 증가
// clientDefault - 기본값으로 지정할 값 지정 (임의적으로 넣으면 넣은 값으로 들어감)
