import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h,),
              Text('Hi, John Doe', style: TextStyle(fontSize: 15.sp),),
              SizedBox(height: 5.h,),
              Text('Favorites'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                elevation: 3,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 30.w,
                                  child: CollectionItem(index: index+1, round: 5, width: 30.w)),
                            );
                      }),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: InkWell(
                        onTap: (){},
                        child: Row(
                          children: [
                            Text('View All', style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w100),),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Text('Shipping Address', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w800)),
              SizedBox(height: 1.h),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.location_solid, color: Colors.grey),
                        SizedBox(width: 2.w,),
                        Text('My Home', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w800, color: Colors.grey),),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text('12 Bay Street, Cairo, Egypt',
                        style: TextStyle(fontFamily: '', fontWeight: FontWeight.w500),),),
                    Divider(),
                    InkWell(
                      onTap: (){
                        navKey.currentState?.pushNamed('/addressPage');
                      },
                      child: Row(
                        children: [
                          Text('Change Default Address', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w100),),
                          Spacer(),
                          Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 5.h,),
              Text('Saved Cards', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w800)),
              SizedBox(height: 1.h),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    border: Border.all(color: Colors.grey.shade300)
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.creditcard_fill),
                        SizedBox(width: 2.w,),
                        Text('***-7777', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w600)),
                        Spacer(),
                        Text('Expire at 12/24', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w600))
                      ],
                    ),
                    Divider(color: Colors.grey),
                    InkWell(
                      onTap: (){
                        navKey.currentState?.pushNamed('/editCards');
                      },
                      child: Row(
                        children: [
                          Text('Edit Cards', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w100),),
                          Spacer(),
                          Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h,),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp)
                        )
                    ),
                    onPressed: (){},
                    child: Text('Logout')),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp)
                        ),
                    ),
                    onPressed: (){},
                    child: Text('Delete Account')),
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }
}
