import 'package:firebase_auth/firebase_auth.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Center(
              child: SizedBox(
                width: 30.w,
                child: AspectRatio(aspectRatio:8/30,
                    child: Image(image: AssetImage('assets/images/logo.png'))),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: (){

              }, icon: Stack(
                children: [
                  Positioned(
                      left: 0,
                      child: Icon(Icons.shopping_cart, size: 7.w,)),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(// This is your Badge
                      padding: EdgeInsets.all(1.w),
                      constraints: BoxConstraints(maxHeight: 5.w, maxWidth: 5.w),
                      decoration: BoxDecoration( // This controls the shadow
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 5,
                              color: Colors.black.withAlpha(50))
                        ],
                        borderRadius: BorderRadius.circular(15.w),
                        color: Colors.grey.shade600,  // This would be color of the Badge
                      ),             // This is your Badge
                      child: Center(
                        // Here you can put whatever content you want inside your Badge
                        child: Text('9+', style: TextStyle(color: Colors.white, fontSize: 5.sp)),
                      ),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h,),
              Text('Hi, John Doe', style: TextStyle(fontSize: 15.sp),),
              SizedBox(height: 5.h,),
              Text('Wishlist', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w800)),
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
                          shrinkWrap: true,
                          itemExtent: 14.5.h,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: CollectionItem(index: index+1, round: 2),
                            );
                      }),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(5.sp),
                        highlightColor: theme.secondaryHeaderColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Row(
                            children: [
                              Text('View All', style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w100),),
                              Spacer(),
                              Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                            ],
                          ),
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
                        navKey.currentState?.pushNamed('/editAddress');
                      },
                      borderRadius: BorderRadius.circular(5.sp),
                      highlightColor: theme.secondaryHeaderColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Row(
                          children: [
                            Text('Change Default Address', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w100),),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                          ],
                        ),
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
                    Divider(),
                    InkWell(
                      onTap: (){
                        navKey.currentState?.pushNamed('/editCards');
                      },
                      borderRadius: BorderRadius.circular(5.sp),
                      highlightColor: theme.secondaryHeaderColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Row(
                          children: [
                            Text('Edit Cards', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w100),),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h,),
              Divider(height: 1.h),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(10.sp),
                highlightColor: theme.textSelectionTheme.selectionColor,
                child: ListTile(
                  iconColor: theme.secondaryHeaderColor,
                  textColor: theme.secondaryHeaderColor,
                  leading: Icon(CupertinoIcons.phone_fill),
                  title: Text('Change Phone Number',  style: TextStyle(fontSize: 9.sp)),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(height: 1.h),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(10.sp),
                highlightColor: theme.textSelectionTheme.selectionColor,
                child: ListTile(
                  iconColor: theme.secondaryHeaderColor,
                  textColor: theme.secondaryHeaderColor,
                  leading: Icon(Icons.key),
                  title: Text('Change Password',  style: TextStyle(fontSize: 9.sp)),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(height: 1.h),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(10.sp),
                highlightColor: theme.textSelectionTheme.selectionColor,
                child: ListTile(
                  iconColor: theme.secondaryHeaderColor,
                  textColor: theme.secondaryHeaderColor,
                  leading: Icon(CupertinoIcons.envelope),
                  title: Text('Change Email', style: TextStyle(fontSize: 9.sp)),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.sp)
                        )
                    ),
                    onPressed: (){},
                    child: Text('Logout')),
              ),
              SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.sp)
                        )
                    ),
                    onPressed: (){},
                    child: Text('Delete Account', style: TextStyle(color: Colors.red),)),
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }
}
