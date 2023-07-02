import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  WebViewController? webViewController;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Hyo Code Factory"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                if(webViewController != null){
                  // 웹뷰에서 보여줄 사이트 실행하기
                  webViewController!.loadUrl("https://blog.codefactory.ai");
                }
              },
              icon: const Icon(
                Icons.home
              ),
          ),
        ],
        leading: IconButton(
          onPressed: (){
            //Navigator.of(context).pop();
            if(webViewController != null){
              webViewController!.goBack();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios
          ),
        ),
      ),
      body: WebView(
        onWebViewCreated: (WebViewController controller){
          webViewController = controller; // 위젯에 컨트롤러 저장
        },
        initialUrl: "https://blog.codefactory.ai",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
