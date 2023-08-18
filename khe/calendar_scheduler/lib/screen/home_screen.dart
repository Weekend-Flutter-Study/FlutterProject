import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
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
              return ScheduleBottomSheet();
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
            _ScheduleList()
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
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          //ListView.separated 는 ListView.builder 보다 parameter가 하나 더 있음 : separatorBuilder
          itemCount: 6, // 몇개의 값을 넣을지
          // 100개 넣어도 -> 바로 100개 빌드 x , 즉 스크롤 내릴때마다 필요한 만큼만 itemBuilder를 실행 -> 메모리 효율 up
          //itemCount 만큼 itemBuilder가 실행됨
          separatorBuilder: (context, int) {
            // itemBuilder 다음에 실행됨
            return const SizedBox(
              height: 8.0,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            print(index);
            return ScheduleCard(
              startTime: 8,
              endTime: 14,
              content: '프로그래밍 공부하기 ${index + 1}',
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}


