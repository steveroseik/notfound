import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';

class PreCheckOutPage extends StatefulWidget {
  const PreCheckOutPage({super.key});

  @override
  State<PreCheckOutPage> createState() => _PreCheckOutPageState();
}

class _PreCheckOutPageState extends State<PreCheckOutPage> {

  late BlackBox box;
  late AddressItem defAddress;
  bool cashPayment = false;
  bool cashValid = true;
  bool loading = false;
  late List<Item> items;

  isCashValid(){
    if (defAddress.zone.contains('Cairo') ||
        defAddress.zone.contains('Alexandria') ||
        defAddress.zone.contains('North Coast')) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    defAddress = box.defaultAddress();
    cashValid = isCashValid();
    items = box.cartToReceipt(object: true);
    return Scaffold(
      appBar: MyAppBar(context: context, box: box, showCart: false, restricted: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Stack(
          children: [
            SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          child: Text('DISCLAIMER: Please note that all payments, whether made in cash or via Visa, are processed exclusively in Egyptian Pounds (EGP). Therefore, the total amount displayed during checkout and the charged amount will be in Egyptian Pounds.',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9.sp, color: Colors.grey),
                          textAlign: TextAlign.justify,),
                        ),
                        SizedBox(height: 3.h),
                        Text('Order Summary',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                        SizedBox(height: 2.h),
                        PhysicalModel(
                          color: Colors.transparent,
                          elevation: 8.0,
                          shadowColor: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                          clipBehavior: Clip.antiAlias,
                          child: ClipPath(
                            clipper: ReceiptClipper(),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 3.w),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ListView.builder(
                                      itemCount: items.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index){
                                        return Container(
                                          padding: EdgeInsets.only(bottom: 1.h),
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
                                              TextSpan(text: 'EGP '),
                                              TextSpan(text: box.cartTotalPrice('EGP').toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text('Shipping Info',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                        SizedBox(height: 1.h),
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed('/editAddress', arguments: false),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.sp),
                                  color: Colors.white
                              ),
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(CupertinoIcons.location_solid, color: Colors.black,
                                          size: 16.sp),
                                      SizedBox(width: 2.w,),
                                      Text(defAddress.name,
                                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 12.sp),),
                                    ],
                                  ),
                                  SizedBox(height: 1.5.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 1.5.w),
                                    child: Text('${defAddress.address.capitalizeAllWords()}, ${defAddress.details.capitalizeAllWords()}, ${defAddress.city.capitalizeAllWords()}, ${defAddress.country.capitalizeAllWords()}',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp),),
                                  ),
                                  defAddress.zipcode.isNotEmpty ? Padding(
                                    padding: EdgeInsets.only(left: 1.5.w),
                                    child: Text(defAddress.zipcode,
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp),),
                                  ) : Container(),
                                  SizedBox(height: 2.h,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                                    child: Row(
                                      children: [
                                        Text('Change Default Address',
                                          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w100),),
                                        Spacer(),
                                        Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text('Payment Method',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cashValid ? InkWell(
                              onTap: (){
                                setState(() {
                                  cashPayment = true;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.sp),
                                ),
                                color: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 40.w,
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.sp),
                                    border: cashPayment ? Border.all(width: 3, color: blueColor) : null,
                                      color: cashPayment ? Colors.white : Colors.transparent
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 15.w,
                                          width:  15.w,
                                          child: Image.asset('assets/images/cash.png')),
                                      SizedBox(height: 1.h),
                                      const Text('Cash On Delivery',
                                      style: TextStyle(fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            cashValid ? SizedBox(width: 3.w) : Container(),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  cashPayment = false;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.sp),
                                ),
                                color: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 40.w,
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.sp),
                                      border: !cashPayment ? Border.all(width: 3, color:blueColor) : null,
                                      color: !cashPayment ? Colors.white : Colors.transparent
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 15.w,
                                          width:  15.w,
                                          child: Image.asset('assets/images/card.png')),
                                      SizedBox(height: 1.h),
                                      const Text('Card Payment',
                                        style: TextStyle(fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.sp)
                        )
                    ),
                    onPressed:  () {
                      if (!cashValid || !cashPayment){
                        proceedToCardPayment();
                      }else{
                        proceedToCashPayment();
                      }
                    },
                    child: FittedBox(child: Text("Place Order",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp))),
                  ),
                ),
              ],
            ),
          ),
          loading ? loadingWidget(loading) : Container()
          ],
        ),
      ),
    );
  }

  proceedToCardPayment() async{
    setState(() {
      loading = true;
    });
    final g = await createOrderPayment(box);
    if ( g != null) {
      await Navigator.of(context).pushNamed('/payOnline', arguments: [g, items]);
      setState(() {
        loading = false;
      });
    }else{
      showErrorBar(context, 'Failed to initiate online payment, please try again.');
    }

  }

  proceedToCashPayment() async{
    setState(() {
      loading = true;
    });
    final g = await createOrderPayment(box, cash: true, fullReceipt: true);
    if ( g != null) {
      await box.clearCart();
      Navigator.of(context).pushNamedAndRemoveUntil('/cashSuccess', (route) => false, arguments: g);
      return;
    }else{
      showErrorBar(context, 'Failed to initiate cash payment, please try again.');
    }
    setState(() {
      loading = false;
    });
  }
}
