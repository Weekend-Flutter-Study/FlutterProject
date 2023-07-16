import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';

class SettingsScreen extends StatelessWidget {
  final double threshold; // Slider의 현잿값
  final ValueChanged<double> onThresholdChange;

  const SettingsScreen(
      {required this.threshold, required this.onThresholdChange, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text(
                '민감도',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // 민감도를 높일 수록 더 강하게 흔들어야 난수가 생성된다.
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101, // 최솟값과 최댓값 사이 구간 개수
          value: threshold, //슬라이더 선택값
          onChanged: onThresholdChange, // 값 변경 시 실행되는 함수
          label: threshold.toStringAsFixed(1), // 표싯값 // 소수점 1자리까지 표시
        )
      ],
    );
  }
}
