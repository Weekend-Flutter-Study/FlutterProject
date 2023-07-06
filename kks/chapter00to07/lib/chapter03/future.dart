Future<void> main() async {
   await addNumbers2(1, 2);
   addNumbers2(2, 3);
}

void addNumbers1(int number1, int number2) {
  print('계산 시작!');
  var sum = 0;

  Future.delayed(const Duration(seconds: 3), () {
    sum = number1 + number2;
  });

  print('합 : $sum');
}

Future<void> addNumbers2(int number1, int number2) async {
  print('계산 시작!');
  var sum = 0;

  await Future.delayed(const Duration(seconds: 3), () {
    print('더하는중...');
    sum = number1 + number2;
  });

  print('합 : $sum');
}
