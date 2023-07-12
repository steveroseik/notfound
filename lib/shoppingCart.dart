import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {

  late BlackBox box;
  final _key = GlobalKey<AnimatedListState>();
  bool tapped = false;


  @override
  void dispose() {
    box.updateCart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(
      appBar: MyAppBar(context: context, box: box, showCart: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(1.w),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child,),
            child: box.cartLength > 0 ? Column(
              children: [
                Expanded(
                  child: AnimatedList(
                      key: _key,
                      initialItemCount: box.cartLength,
                      itemBuilder: (context, index, animation){
                        final item = box.cartItems[index];
                        bool maximum = false;
                        final currency = item.product.prices.firstWhere((e) => e.currency == box.currentCurrency);
                        final total = int.tryParse(currency.priceAfterDiscount)! * item.quantity;
                        return buildItem(item, maximum, total, index, animation);
                      }),
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2.w),
                    child: Row(
                      children: [
                        Text('Total',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),),
                        Spacer(),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeight.w300),
                              children: [
                                TextSpan(text: '${box.currentCurrency} '),
                                TextSpan(text: box.cartTotalPrice(box.currentCurrency).toString(), style: const TextStyle(fontWeight: FontWeight.w700)),
                              ]
                          ),
                        ),
                      ],
                    )
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  width: double.infinity,
                  height: 5.h,
                  child: ElevatedButton(onPressed: () async{
                    if (FirebaseAuth.instance.currentUser == null){
                      final resp = await showAlertSheet(context, title: "You're not logged in",
                      subtitle: 'You need to login to your account in order to continue',
                      yesNo: true);
                      if (resp) box.signOut();
                    }else{
                      preCheckOut();
                    }
                  }, child: const Text('CHECKOUT')),
                )
              ],
            ) :
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 45.sp, color: Colors.grey),
                  SizedBox(height: 1.h),
                  Center(
                    child: Text("YOUR CART IS EMPTY",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.grey), textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    width: double.infinity,
                    height: 5.h,
                    child: ElevatedButton(onPressed: (){
                     Navigator.of(context).pop();
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                        ),
                        child: const Text('GO BACK TO SHOPPING')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildItem(CartItem item, bool maximum, int total, int index, Animation<double> animation){
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: SizedBox(
          height: 12.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  child: cachedImage(item.product.mainPhotoPath)),
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.product.name.capitalizeAllWords(),
                    style: const TextStyle(fontWeight: FontWeight.w800),),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3.sp)
                    ),
                    child: Text(item.size.name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 8.sp),),
                  ),
                  SizedBox(height: 1.h),
                  Text('${box.currentCurrency} ${total.toString()}',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10.sp
                    ),)
                ],
              ),
              Spacer(),
              SizedBox(
                width: 10.w,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.sp),
                      color: Colors.grey.shade300
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          if (!maximum) maximum = box.incrementCartItem(context, item);
                        },
                        child: Icon(CupertinoIcons.plus, color: Colors.grey.shade600,),
                      ),
                      SizedBox(height: 1.h,),
                      Text(item.quantity.toString(), style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(height: 1.h,),
                      InkWell(
                          onTap: tapped ? null : () async{
                            setState(() {
                              tapped = true;
                            });
                            final deleted = box.decrementCartItem(item);
                            if (deleted != null) {
                              _key.currentState?.
                              removeItem(index, (context, animation) => buildItem(item, maximum, total, index, animation));
                              await Future.delayed(const Duration(milliseconds: 300));
                            }
                            setState(() {
                              tapped = false;
                            });
                          },
                          child: Icon(item.quantity == 1 ? Icons.delete_forever : CupertinoIcons.minus, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  addressAlert() async{
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,

        context: context,
        builder: (context){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
            color: Colors.white,
            height: 30.h,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No Address Found',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp)),
                  SizedBox(height: 3.h,),
                  Text('You need to add an address first.',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp)),
                  SizedBox(height: 1.h,),
                  // Text('This action is cannot be undone.',
                  //   style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade700),),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: CupertinoColors.extraLightBackgroundGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.sp)
                              )
                          ),
                          onPressed:  () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: blueColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.sp)
                              )
                          ),
                          onPressed:  () {
                            Navigator.of(context).pop(true);
                          },
                          child: const FittedBox(child: Text("Goto Addresses", style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
    ).then((value) => {
      if (value != null && value) Navigator.of(context).pushNamed('/editAddress')
    });
  }
  preCheckOut() async{
    if (box.userAddresses.isEmpty || !box.hasDefaultAddress){
      addressAlert();
    }else if (box.userPod()!.phoneNumber == 'null'){
      final resp = await showAlertSheet(context,
      title: 'No phone number assigned',
      subtitle: 'Add a phone number to your account in order to proceed.', yesNo: true);
      if (resp) Navigator.of(context).pushNamed('/phonePage');
    }else{
      Navigator.of(context).pushNamed('/preCheckOut');
    }
  }
}
