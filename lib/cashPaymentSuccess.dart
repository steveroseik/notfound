import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/objects.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';

class CashPaymentSuccessPage extends StatefulWidget {
  final Receipt order;
  const CashPaymentSuccessPage({super.key, required this.order});

  @override
  State<CashPaymentSuccessPage> createState() => _CashPaymentSuccessPageState();
}

class _CashPaymentSuccessPageState extends State<CashPaymentSuccessPage> {

  late BlackBox box;
  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          height: 8.h,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.center,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5.h,),
                Icon(Icons.check_circle_rounded, size: 130.sp, color: Colors.green),
                SizedBox(height: 3.h),
                Text('CASH ORDER RECEIVED SUCCESSFULLY',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 20.sp),
                  textAlign: TextAlign.center,),
                SizedBox(height: 5.h),
                SizedBox(
                  width: double.infinity,
                  child: Text('Order Summary',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),),
                ),
                SizedBox(height: 2.h),
                ClipPath(
                  clipper: ReceiptClipper(),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                          child: ListView.builder(
                              itemCount: widget.order.items.length,
                              itemBuilder: (context, index){
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('${widget.order.items[index].quantity} ',
                                        style: const TextStyle(fontWeight: FontWeight.w400),),
                                      SizedBox(width: 1.w),
                                      AutoSizeText(widget.order.items[index].productName.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.fade,
                                        presetFontSizes: const [16, 15, 14, 13, 12, 10, 9, 8, 7],
                                      ),
                                      SizedBox(width: 1.w),

                                      AutoSizeText(
                                        widget.order.items[index].size, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                        presetFontSizes: const [14, 13, 12, 10, 9, 8, 7],),
                                      Spacer(),
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w300),
                                            children: [
                                              TextSpan(text: 'EGP '),
                                              TextSpan(text: widget.order.items[index].price.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
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
                                    TextSpan(text: 'EGP '),
                                    TextSpan(text: widget.order.amount.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: Text('You can view all your past orders by going to your account page.',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    child: Text('CLOSE'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
