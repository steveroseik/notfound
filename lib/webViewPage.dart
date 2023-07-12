import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String session;
  const WebViewPage({Key? key, required this.session}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}
class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller2;
  late Timer timer;
  String prevLink = '';
  int percentage = 1;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  ValueNotifier<bool> _keyboardVisible = ValueNotifier(false);


  @override
  void initState() {
    _controller2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              percentage = progress;
            });
          },
          onPageStarted: (String url) {
            if (url.startsWith('https://sroseik-session-end.com')){
              navKey.currentState?.pop(url);
            }
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            print('WRE: $error');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://cib-gateway.vercel.app/try2.html?sessionId=${widget.session}'));
    super.initState();
  }

  @override
  void dispose() {
    // if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible.value = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Gateway'),
        ),
        body:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              WebViewWidget(
                controller: _controller2,
                gestureRecognizers: gestureRecognizers,
              ),
             ValueListenableBuilder(valueListenable: _keyboardVisible, builder: (context, value, child){
               return  _keyboardVisible.value ? Container() : Positioned(
                   bottom: 5.w,
                   child: IconButton(
                     onPressed: (){
                       _controller2.reload();
                     },
                     icon: const Icon(Icons.refresh, size: 30,),
                   )
               );
             }),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 1.h,
                    animationDuration: 2500,
                    percent:  percentage / 100,
                    linearGradient: const LinearGradient(colors: [Colors.black, blueColor]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


