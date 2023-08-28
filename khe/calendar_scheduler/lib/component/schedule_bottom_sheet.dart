import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/category_color.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

import '../const/colors.dart';

class ScheduleBottomSheet extends StatefulWidget {
  // text의 상태 관리를 위해 stateless -> stateful로 변경
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  //data 관리 id
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    //viewInsets : 시스템으로 가려진 부분 가져 올 수 있음
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // 키보드가 차지하는 부분이 몇 픽셀인지 알 수 있음

    return GestureDetector(
      onTap: () {
        // 키보드 닫힘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
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
              // TextFormField를 이용해 한번에 관리하기 위해 여러 텍스트필드 상단 위에 Form을 래핑하여 사용,
              // Column 위에도 괜찮고, 더 상단도 괜찮음
              child: Form(
                // key : Form의 일종의 컨트롤러
                key: formKey,
                // autovalidateMode: AutovalidateMode.always,
                // 저장 키를 누르지 않아도, 입력할때마다 검증가능
                child: Column(// material package에서 불러오는 Column
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSaved: (String? val) {
                        // 값을 저장하여 어딘가에서 반복적 사용하길 원함
                        startTime = int.parse(val!);
                      },
                      onEndSaved: (String? val) {
                        // validate 에서 null 이면 에러 메세지 던지라고 했기 때문에 ! 해도 괜찮다.
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
                          // print(snapshot.data);
                          if (snapshot.hasData &&
                              selectedColorId == null &&
                              snapshot.data!.isNotEmpty) {
                            // 자동으로 빨간색 선택
                            selectedColorId = snapshot.data![0].id;
                          }
                          return _ColorPicker(
                            colors: snapshot.hasData ? snapshot.data! : [],
                            seletedColorId: selectedColorId,
                            // 언제 널이 될수있는지? 데이터가 없을때 즉 로딩때
                            colorIdSetter: (int id) {
                              setState(() {
                                // 색상을 누를때마다 보더가 바뀌면서 선택됨을 알 수 있음
                                selectedColorId = id;
                              });
                            },
                          );
                        }),
                    SizedBox(height: 8.0),
                    _SaveButton(
                      onPressed: onSavePressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을 때
    if (formKey.currentState == null) {
      return;
    }

    // formkey 사용하여 3개의 텍스트필드를 검증 - 한번에 다 실행.
    if (formKey.currentState!.validate()) {
      // String을 return 하면 에러메세지로 간주하기 때문에 우리를 이를 활용하여 에러메세지로 보여줄 수 있음
      // null을 리턴하면 에러가 없다. 모든 텍스트 필드가 null 을 리턴하면 true 뭐라도 있으면 false
      // print('에러가 없습니다.');

      // 에러가 없으면 저장
      formKey.currentState!.save();
      // print('------------------');
      // print('startTime : $startTime');
      // print('endTime : $endTime');
      // print('content : $content');

      // save를 성공적으로 마쳤을때 스케줄 생성
      final key = await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          date: Value(widget.selectedDate),
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorId: Value(selectedColorId!),
        ),
      );

      Navigator.of(context).pop();
      // print('SAVE 완료 $key');
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    Key? key,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? seletedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.seletedColorId,
    required this.colorIdSetter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // row로 하면 넘어가면 오류 -> 알아서 화면 넘어가면 내림 -> wrap
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  // 어떤 id의 색깔을 눌렀는지 상위 위젯에 알려줘야 함 -> typedef 선언
                  colorIdSetter(e.id); // 각각의 색상을 누를때 외부에서 받은 colorIdSetter를 사용,
                  // 실행할때 파라미터에 어떤색깔이 선택됐는지 각각 색깔의 id를 전달해줌
                },
                child: renderColor(
                  e,
                  seletedColorId == e.id, // 선택된 상태
                ),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // map 을 통해 각각의 값을 받을 수 있음
        // int.parse를 하면 10진수, radix 16하면 16진수
        color: Color(
          int.parse(
            'FF${color.hexCode}',
            radix: 16,
          ),
        ),
        border: isSelected ? Border.all(color: Colors.black, width: 4.0) : null,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

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
