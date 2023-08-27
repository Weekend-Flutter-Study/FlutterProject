import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  // true - 시간 / false - 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        if(isTime) renderTextField(),
        if(!isTime)
          Expanded(child: renderTextField())
      ],
    );
  }
  Widget renderTextField(){
    return TextFormField(
      // 외부에서 입력
      onSaved: onSaved,
      // FORM을 가지고 동시에 관리
      // onChange를 쓸 수 있지만 안써도 o
      validator: (String? val){
        // validator : null 이 return 되면 에러가 없다.
        // 에러가 있으면 에러를 String 값으로 리턴해준다.
       if(val == null || val.isEmpty){
         return '값을 입력해주세요';
       }

       if(isTime){
         int time = int.parse(val);
         if(time < 0){
           return '0 이상의 숫자를 입력해주세요';
         }

         if(time > 24){
           return '24 이하의 숫자를 입력해주세요';
         }
       }else{
         if(val.length > 500){
           return '500자 이하의 글자를 입력해주세요.';
         }
       }

       return null;
        //기본은 return null;
      },
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      // maxLength: 500,
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime ? [
        FilteringTextInputFormatter.digitsOnly
      ] : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
