import 'package:flutter/material.dart';
import 'package:notfound/webViewPage.dart';


class PaymentPage extends StatefulWidget {
  final String session;
  const PaymentPage({Key? key, required this.session}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebViewPage(session: widget.session)
      ),
    );
  }
}
