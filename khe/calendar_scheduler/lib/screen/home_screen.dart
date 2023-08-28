import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // utc 기준
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDate: selectedDay,
              );
            },
          );
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 3,
            ),
            const SizedBox(height: 8.0),
            _ScheduleList(
              selectedDate: selectedDay,
            )
          ],
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      // print(selectedDay);
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (context, snapshot) {
              // print('-------original data -------');
              // print(snapshot.data);
              //
              // List<Schedule> schedules = [];
              //
              // if (snapshot.hasData) {
              //   // 이렇게 하면 모든 스케줄을 다 불러와 버린다.
              //   // 그러면 메모리에 모든 값이 올라가므로 x, 해당 날짜의 데이터만 불러오게끔 변경 필요
              //   // LocalDatabase 클래스, watchSchedules에됨 쿼리를 날릴때 제한된 쿼리를 날리도록 변경 필요
              //   schedules = snapshot.data!
              //       .where((element) => element.date.toUtc() == selectedDate)
              //       .toList();
              //
              //   print('-------filtered data -------');
              //   print('selectedDate $selectedDate');
              //   print(schedules);
              // }


              // 위에 소스는 database에서 애초에 필터링 하기 전 소스
              print(snapshot.data);
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }

              if(snapshot.hasData && snapshot.data!.isEmpty){
                return Center(
                  child: Text('스케줄이 없습니다.'),
                );
              }


              return ListView.separated(
                //ListView.separated 는 ListView.builder 보다 parameter가 하나 더 있음 : separatorBuilder
                // itemCount: schedules.length,
                itemCount: snapshot.data!.length,
                // 몇개의 값을 넣을지
                // 100개 넣어도 -> 바로 100개 빌드 x , 즉 스크롤 내릴때마다 필요한 만큼만 itemBuilder를 실행 -> 메모리 효율 up
                //itemCount 만큼 itemBuilder가 실행됨
                separatorBuilder: (context, int) {
                  // itemBuilder 다음에 실행됨
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  // print(index);
                  final schedule = snapshot.data![index];

                  return ScheduleCard(
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    content: schedule.content,
                    color: Colors.red,
                  );
                },
              );
            }),
      ),
    );
  }
}
