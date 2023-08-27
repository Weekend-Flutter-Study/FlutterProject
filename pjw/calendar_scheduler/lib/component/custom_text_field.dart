import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;

  const CustomTextField({
    required this.label,
    required this.isTime,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(child: renderTextField())
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      /* TextFormField = TextField + 추가 기능 */
      /* validator : null return = NO ERROR */
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }
        return null;
      },
      cursorColor: Colors.grey,
      expands: !isTime, /* 최대로 늘릴꺼냐? */
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      maxLines: isTime ? 1 : null, /* null 넣으면 무제한으로 늘어남 */
      inputFormatters: isTime ? [ /* 키보드로 입력하는 것까지 막아줌 */
        FilteringTextInputFormatter.digitsOnly
      ] : [], /* Time 입력이 아니면 제한 없애기 */
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
