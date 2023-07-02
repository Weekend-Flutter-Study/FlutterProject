import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HomeScreen extends StatelessWidget {

  WebViewController? controller;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Jaewon Dev'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (controller != null) {
                  controller!.loadUrl('https://blog.codefactory.ai');
                }
              },
              icon: Icon(
                Icons.home_filled,
              ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back
          ),
          onPressed: (){
            if (controller != null) {
              controller!.goBack();
            }
          },
        ),

      ),

      body: WebView(
        initialUrl: 'https://blog.codefactory.ai',
        javascriptMode: JavascriptMode.unrestricted,

        onWebViewCreated: (WebViewController controller) {
          // Widget 에 컨트롤러 저장
          this.controller = controller;
        },
      ),

    );
  }
}
