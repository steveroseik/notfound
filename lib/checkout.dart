import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notfound/api_lib.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class CheckOutOnline extends StatefulWidget {
  final String data;
  final List<Item> items;
  const CheckOutOnline({Key? key, required this.items, required this.data}) : super(key: key);

  @override
  State<CheckOutOnline> createState() => _CheckOutOnlineState();
}

class _CheckOutOnlineState extends State<CheckOutOnline> {

  String sessId = '';
  String sIndicator = '';
  String orderId = '';
  String textInd = '';
  bool loading = true;
  int paymentSuccess = -1;
  late BlackBox box;
  late Receipt order;

  @override
  void initState() {
    orderId = widget.data;
    validateOrder();
    super.initState();
  }

  void validateOrder() async{
    try{
      final g = await FirebaseFirestore.instance
          .collection('orders').where(FieldPath.documentId, isEqualTo: orderId).get();
      if (g.docs.isEmpty) {
        Navigator.of(context).pop();
        return;
      }
      order = Receipt.fromShot(g.docs.first.data(), g.docs.first.id);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => generatePaymentSession());
    }catch(e){
      print('validate Order error: $e');
    }
  }

  void generatePaymentSession({bool? retry}) async{
    try{
      if (retry == null || !retry){
        final response = jsonDecode(await requestSession(orderId: orderId, amount: box.cartTotalPrice('EGP')));
        if (response['session']['id'] != null){
          sessId = response['session']['id'];
          sIndicator = response['successIndicator'];
        }
      }
      if (paymentSuccess != -1){
        setState(() {
          paymentSuccess = -1;
        });
      }
      navKey.currentState?.pushNamed('/pay', arguments: sessId).then((value) {
        if (value is String) {
          validatePayment(value);
        }else{
          setState(() {
            paymentSuccess = 0;
            textInd = 'Error (119): Could not retrieve url';
            loading = false;
          });
        }
      });
    }catch (e){
      setState(() {
        textInd = 'Error (420): Failed to start session';
        paymentSuccess = 0;
        loading = false;
      });
    }
  }

  validatePayment(String url) async{
    bool pass = false;
    String? orderFinalId;
    String? resultIndicator;
   try{
     // extract url parameters
     int orderIdStartIndex = url.indexOf('orderId=') + 'orderId='.length;
     int orderIdEndIndex = url.indexOf('?');
     orderFinalId = url.substring(orderIdStartIndex, orderIdEndIndex);

     int resultIndicatorStartIndex = url.indexOf('resultIndicator=') + 'resultIndicator='.length;
     int resultIndicatorEndIndex = url.indexOf('&', resultIndicatorStartIndex);
     if (resultIndicatorEndIndex == -1) {
       resultIndicatorEndIndex = url.length;
     }
     resultIndicator = url.substring(resultIndicatorStartIndex, resultIndicatorEndIndex);
     if (orderFinalId == orderId && resultIndicator == sIndicator) pass = true;
   }catch (e){
     setState(() {
       textInd = 'Error (120): Failed to identify url.';
       paymentSuccess = 0;
       loading = false;
     });
   }
   if (pass){
     // double check
     final orderResponse = jsonDecode(await getOrderDetails(orderFinalId!));
     if (orderResponse['status'] == 'CAPTURED'){
       setState(() {
         paymentSuccess = 1;
         textInd = 'PAYMENT RECEIVED SUCCESSFULLY!';
         loading = false;
       });

       await updateOrderPayment(orderId);
       box.fulfillReceipt(orderId);
       await box.clearCart();
       Navigator.of(context).pushNamedAndRemoveUntil('/paymentSuccess', (route) => false, arguments: order);
     }
   }else{
     setState(() {
       textInd = 'orderId: $orderFinalId \n' 'Indicator: $resultIndicator';
       paymentSuccess = 0;
       loading = false;
     });
   }

  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    final items = widget.items;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: double.infinity,
            height: 8.h,
            child: Stack(
              children: [
                Align(
                  widthFactor: 1.2.sp,
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 30.w,
                    child: const AspectRatio(aspectRatio:8/30,
                        child: Image(image: AssetImage('assets/images/logo.png'))),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Center(
                child: FittedBox(
                  child: Text('Order ID: \n\n$orderId',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,),
                ),
              ),
              SizedBox(height: 5.h),
              Text('Order Summary',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),),
              Card(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          itemCount: items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('${items[index].quantity} ',
                                    style: const TextStyle(fontWeight: FontWeight.w400),),
                                  SizedBox(width: 1.w),
                                  AutoSizeText(items[index].productName.toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.fade,
                                    presetFontSizes: const [16, 15, 14, 13, 12, 10, 9, 8, 7],
                                  ),
                                  SizedBox(width: 1.w),

                                  AutoSizeText(
                                      items[index].size, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  presetFontSizes: const [14, 13, 12, 10, 9, 8, 7],),
                                  Spacer(),
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w300),
                                        children: [
                                          TextSpan(text: 'EGP '),
                                          TextSpan(text: items[index].price.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Divider(),
                      Row(
                        children: [
                          Text('Total Amount',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),),
                          Spacer(),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w300),
                                children: [
                                  TextSpan(text: '${box.currentCurrency} '),
                                  TextSpan(text: box.cartTotalPrice(box.currentCurrency).toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 7.h),
              loading ? const Center(child: CircularProgressIndicator(color: Colors.black)) :
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    paymentSuccess == 0 ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'FAILED TO PROCESS PAYMENT\n \n',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.red, fontSize: 16.sp),),
                        TextSpan(text: 'Problem info:\n $textInd\n\n',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
                        TextSpan(text: 'If You believe there is a problem, take a screenshot of this page and contact us.',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.sp))
                      ]
                    )) : Container(),
                    paymentSuccess == 1 ? const Text('PAYMENT RECEIVED SUCCESSFULLY!',
                    style: TextStyle(fontWeight: FontWeight.w500)) : Container(),
                  ],
                ),
              ),
              Spacer(),
              paymentSuccess == -1 ? Center(
                child: Text('DO NOT CLOSE THIS PAGE!',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.red)),
              ) : Container(),
              paymentSuccess != -1 ? SizedBox(
                width: double.infinity,
                child: paymentSuccess == 1 ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.sp)
                      )
                  ),
                  onPressed:  () {
                    Navigator.of(context).pop();
                  },
                  child: FittedBox(child: Text("Close Page",
                      style: TextStyle(color: Colors.white, fontSize: 12.sp))),
                ) : paymentSuccess == 0 ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            )
                        ),
                        onPressed:  () {
                          Navigator.of(context).pop();
                        },
                        child: FittedBox(child: Text("Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 12.sp))),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            )
                        ),
                        onPressed:  () {
                          generatePaymentSession(retry: true);
                        },
                        child: FittedBox(child: Text("Retry",
                            style: TextStyle(color: Colors.white, fontSize: 12.sp))),
                      ),
                    ),
                  ],
                ) : Container(),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
