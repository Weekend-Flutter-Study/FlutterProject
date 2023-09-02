import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
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
      onSaved: onSaved,
      /* TextFormField = TextField + 추가 기능 */
      /* validator : null return = NO ERROR */
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }

        if (isTime) {
          /* 아래에 있는 inputFormatters 를 통해 int로 들어오는지 알 수 있음 */
          int time = int.parse(val);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          // 내용에 대한 Valid 는 지금은 굳이 필요가 없음!
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
