import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate =
  DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [] 안에 진하기 선택 가능 ! 100 ~ 900 (기본은 500)
      // 그럼 디자이너가 생은 어떻게 줌?
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        bottom: false,
        // 위에 공백에 안겹칠 수 있다!
        child: Container(
          // 가운데 정렬은 MediaQuery
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: [
              _TopPart(
                selectedDate: selectedDate,
                onPressed: onHeartPressed,
              ),
              _BottomPart()
            ],
          ),
        ),
      ),
    );
  }

  void onHeartPressed() {
    DateTime now  = DateTime.now();

    showCupertinoDialog(
        context: context,
        barrierDismissible: true, // 외부 누르면 Dismiss
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 300.0, // 어디를 기준으로 하는지 모르면 전체로 잡음
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                // 한계치 정하기
                initialDateTime: selectedDate, // 첫 세팅 안해주면 오류남
                maximumDate: DateTime(
                  now.year,
                  now.month,
                  now.day,
                ),
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                }, // on 이 들어가면 함수다!
              ),
            ),
          );
        });
  }
}

class _TopPart extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPressed;

  const _TopPart({required this.selectedDate, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // of 쓰는건 상속 관련 (가장 가까운거 가져옴)
    final theme = Theme.of(context); // Tree 에서 가장 가까운 theme 가져옴
    final textTheme = theme.textTheme;
    final now = DateTime.now();

    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, // 균등하게 퍼짐!
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등하게 퍼짐!
        children: [
          Text(
            'U&I',
            style: textTheme.headline1,
          ),
          Column(
            // 상위 균등하게 띄어주는 것을 막아주는 역할
            children: [
              Text(
                '우리 처음 만난날',
                style: textTheme.bodyText1
              ),
              Text(
                '${selectedDate.year}.${selectedDate.month}.${selectedDate
                    .day}',
                style: textTheme.bodyText2
              ),
            ],
          ),
          IconButton(
            iconSize: 60.0,
            onPressed: onPressed,
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Text(
            // 날짜 비교하는 방법
            'D+${DateTime(now.year, now.month, now.day)
                .difference(selectedDate)
                .inDays + 1}',
            style: textTheme.headline2
          )
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.asset('asset/img/middle_image.png'));
  }
}
