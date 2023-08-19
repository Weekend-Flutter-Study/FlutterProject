import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  /* 간단하게 정각만 표시할 것임 */
  /* 자세히 하려면 DateTime */
  final int startTime;
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight( /* match_parent (가장 큰 height에 기준을 맞춤) */
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Time(startTime: startTime, endTime: endTime),
                SizedBox(width: 16.0),
                _Content(content: content),
                SizedBox(width: 16.0),
                _Category(color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* 전체적으로 같은 스타일을 쓰면 이렇게 빼서 씀 */
    final textStyle = TextStyle(
        fontWeight: FontWeight.w600,
        color: PRIMARY_COLOR,
        fontSize: 16.0
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* padLeft : 글자 수 최소값은 보장 param에 공백 뭐로 할거지 설정 */
        Text(
            '${startTime.toString().padLeft(2, '0')}:00',
            style: textStyle
        ),
        Text(
            '${endTime.toString().padLeft(2, '0')}:00',
            style: textStyle.copyWith(fontSize: 10.0) /* 특정값만 변경 */
        ),
      ],
    );
  }
}

/* 스케쥴 내용 */
class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* weight 0 */
    return Expanded(
      child: Text(
        content,
      ),
    );
  }
}

class _Category extends StatelessWidget {
  final Color color;

  const _Category({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 16.0,
      height: 16.0,
    );
  }
}
