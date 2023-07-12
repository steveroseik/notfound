

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> requestSession({required String orderId, required int amount}) async {
  const String url =
      'https://cibpaynow.gateway.mastercard.com/api/rest/version/71/merchant/TESTCIB701056/session';
  const String username = 'merchant.TESTCIB701056';
  const String password = '147ee57e1df75948bc375850d3a512ee';

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  final Map<String, dynamic> requestBody = {
    'apiOperation': 'INITIATE_CHECKOUT',
    'checkoutMode': 'WEBSITE',
    'interaction': {
      'operation': 'PURCHASE',
      'merchant': {'name': 'NOTFOUND', 'url': 'https://www.notfoundco.com'},
      'displayControl': {'billingAddress': 'HIDE', 'customerEmail': 'HIDE'},
      'returnUrl': 'https://sroseik-session-end.com/orderId=$orderId',
    },
    'order': {
      'currency': 'EGP',
      'amount': amount,
      'id': orderId,
      'description': 'Mobile App Order'
    },
    'paymentLink': {
      'expiryDateTime': '2021-05-31T15:18:00.993Z',
      'numberOfAllowedAttempts': '3'
    }
  };

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': basicAuth,
  };

  try {
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(requestBody));

    return response.body;
  } catch (e) {
    // Exception occurred, handle the error
    print('Exception: $e');
  }
  return '';
}

getOrderDetails(String orderId) async{
  String url =
      'https://cibpaynow.gateway.mastercard.com/api/rest/version/71/merchant/TESTCIB701056/order/$orderId';
  const String username = 'merchant.TESTCIB701056';
  const String password = '147ee57e1df75948bc375850d3a512ee';

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': basicAuth,
  };

  try{
    final request = await http.get(Uri.parse(url), headers: headers);

    return request.body;
  }catch (e){
    //TODO: can try again to make sure no problem with connection
    return '';
  }
}

getFromNotfound(String endLink) async{
  String url =
      'https://api.notfoundco.com/$endLink';
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'apiKey': 'da5a590c-afe5-4e8e-a7d8-15932911e292',
  };

  try{
    final request = await http.get(Uri.parse(url), headers: headers);
    return request.body;
  }catch (e){

    return '';
  }
}