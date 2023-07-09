import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // Axis 기본 Center
          crossAxisAlignment: CrossAxisAlignment.start, // start 정렬
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('랜덤 숫자 생성기'),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('123'),
                    Text('456'),
                    Text('789'),
                  ],
                ),
            ),
            // Container 로 사용해도 괜찮지만, 정확히 어떤 View 인지 명확한게 SizedBox
            // Container(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //       onPressed: () {},
            //       child: Text('생성하기')
            //   ),
            // )
            SizedBox(
              width: double.infinity, // 양 끝까지 채우는 방법
              child: ElevatedButton(
                  onPressed: () { },
                  child: Text('생성하기')
              ),
            )
          ],
        ),
      ),
    );
  }
}
