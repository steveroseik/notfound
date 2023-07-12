import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:notfound/main.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';
import 'objects.dart';

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({super.key});

  @override
  State<PastOrdersPage> createState() => _PastOrdersPageState();
}

class _PastOrdersPageState extends State<PastOrdersPage> {
  late BlackBox box;
  bool loading = true;
  List<Receipt>? orders;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => generateReceipts());
    super.initState();
  }
  generateReceipts() async{
    orders = await box.getUserReceipts();
    if (orders == null) {
      showErrorBar(context, 'An error has occured!');
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(
      appBar: MyAppBar(context: context, box: box),
      body: loading? const Center(
        child: CircularProgressIndicator(color: Colors.black),
      ) : Padding(
        padding: EdgeInsets.all(5.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              orders != null && orders!.isEmpty ? Container() : Align(
                alignment: Alignment.centerLeft,
                child: Text('PAST ORDERS',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.sp, color: Colors.grey),),
              ),
              SizedBox(height: 2.h),
              Text('unpaid orders will stay for a duration of one week, after which they will be permanently removed from the system.'.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 9.sp, color: Colors.grey),
              textAlign: TextAlign.center,),
              SizedBox(height: 2.h),
              Builder(
                builder: (context) {
                  if (orders != null && orders!.isEmpty){
                    return SizedBox(
                      height: 60.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty_rounded, size: 45.sp, color: Colors.grey),
                          SizedBox(height: 1.h),
                          Center(
                            child: Text('NO ORDERS YET',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: Colors.grey),),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 80.w,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.sp)
                                  ),
                                ),
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                },
                                child: Text('LEAVE PAGE', style: TextStyle(color:Colors.white, fontSize: 13.sp))),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders!.length,
                      itemBuilder: (context, i){
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: PhysicalModel(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('ID',
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                        Spacer(),
                                        Text(orders![i].id,
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp)),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('TYPE',
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp),),
                                        Spacer(),
                                        Text('${orders![i].type} ',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.sp,
                                              color: Colors.black)),
                                        SizedBox(height: 3.h,
                                            child: Image.asset(orders![i].type.contains('CASH') ?
                                            'assets/images/cash.png' : 'assets/images/card.png'))
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        Text('STATUS',
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp),),
                                        Spacer(),
                                        Text(orders![i].state,
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.sp,
                                              color: orders![i].state.contains('UNPAID') ? Colors.red : Colors.green),),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        Text('DATE',
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp,),),
                                        Spacer(),
                                        Text('${orders![i].createdAt.year}-${orders![i].createdAt.month}-${orders![i].createdAt.day} '
                                            '${orders![i].createdAt.hour}:${orders![i].createdAt.minute}:${orders![i].createdAt.second}',
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp,),),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Divider(),
                                    SizedBox(height: 2.h),
                                    ListView.builder(
                                        itemCount: orders![i].items.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index){
                                          return Container(
                                            padding: EdgeInsets.only(bottom: 1.h),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('${orders![i].items[index].quantity} ',
                                                  style: const TextStyle(fontWeight: FontWeight.w400),),
                                                SizedBox(width: 1.w),
                                                AutoSizeText(orders![i].items[index].productName.toUpperCase(),
                                                  style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.fade,
                                                  presetFontSizes: const [16, 15, 14, 13, 12, 10, 9, 8, 7],
                                                ),
                                                SizedBox(width: 1.w),
                                                AutoSizeText(
                                                  orders![i].items[index].size, overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                                  presetFontSizes: const [14, 13, 12, 10, 9, 8, 7],),
                                                Spacer(),
                                                RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w300),
                                                      children: [
                                                        TextSpan(text: 'EGP '),
                                                        TextSpan(text: orders![i].items[index].price.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                                      ]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    Divider(),
                                    SizedBox(height: 1.h),
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
                                                TextSpan(text: orders![i].amount.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
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
                        );
                      });
                }
              ),
            ],
          ),
        ),
      )
    );
  }


}



