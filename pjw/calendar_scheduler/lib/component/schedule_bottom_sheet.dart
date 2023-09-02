import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/category_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../const/colors.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    /* viewInsets : 시스템으로 가려진 부분 가져 올 수 있음 */
    /* keyBoard 픽셀 확인 가능 */
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        /* Focus null 으로 만들기 -> 키보드 닫힘 */
        /*  */
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea( /* 저장 버튼이 밑으로 빠져나가는 것 방지 */
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: Form(
                // Form : 동시에 관리해주고 싶은 상위에 Form 선언
                // 여기서는 Time, Content 를 동시에 관리해주고 싶음
                key: formKey /* Controller 비슷, 상태관리 = StateFul로 바꿔야함 */,
                autovalidateMode: AutovalidateMode.always, /* 항상 valid 검증 */
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time( // val 받아서 저장하고 싶음
                      onStartSaved: (String? val) {
                        // 앞에서 이미 null 체크 했기때문에 그냥 넘어감
                        startTime = int.parse(val!);
                      },
                      onEndSaved: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    SizedBox(height: 16.0),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(height: 16.0),
                    FutureBuilder<List<CategoryColor>>(
                      future: GetIt.I<LocalDatabase>().getCategoryColors(),
                      builder: (context, snapshot) {
                        return _ColorPicker(
                          colors: snapshot.hasData
                              ? snapshot.data!
                                  .map(
                                    (e) => Color(
                                      int.parse('FF${e.hexCode}', radix: 16),
                                    ),
                                  ).toList()
                              : [],
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    _SaveButton(onPressed: onSavePressed,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() {
    // formkey 생성은 했는데 form widget과 결함이 안되어있음
    if (formKey.currentState == null) {
      return;
    }

    if(formKey.currentState!.validate()) {
      /* Error 가 없음! */
      formKey.currentState!.save();
    } else {
      // textfield 에 에러가 있음

    }

  }

}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;


  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({
    required this.onSaved,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( /* 내용 부분을 크게 늘리기 위해 */
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Color> colors; /* 외부에서 색상 받아옴 */

  const _ColorPicker({required this.colors, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      /* Row 와의 차이점 확인! */
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors.map((e) => renderColor(e)).toList(),
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
