import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'api_lib.dart';
import 'blackBox.dart';
import 'objects.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  BlackBox? box;
  UserPod? pod;
  User? user;
  String _provider = '';
  bool loading = true;
  List<AddressItem> addresses = [];
  AddressItem? defAddress;
  List<ProductElement> likedProducts = [];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) _provider = user!.providerData.first.providerId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    box = BlackNotifier.of(context);
    pod = box!.userPod();
    addresses = box!.addresses;
    defAddress = box!.defaultAddress();
    likedProducts = box!.likedProductsItems();
    return Scaffold(
      appBar: MyAppBar(context: context, box: box!, showLogo: false, title: 'ACCOUNT'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h,),
              Text(pod != null ? 'Hi, ${pod!.firstName} ${pod!.lastName}' :
                'Hi, Guest', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),),
              SizedBox(height: 5.h,),
              Text('WISHLIST', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 1.h),
              Builder(
                builder: (context) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: likedProducts.isEmpty ? 10.h : 25.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.sp),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.sp),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                          child:  likedProducts.isEmpty ?
                          SizedBox(
                            height: 10.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.heart_broken_rounded,
                                color: Colors.grey,
                                size: 15.sp),
                                SizedBox(width: 2.w),
                                Text('YOUR WISHLIST IS EMPTY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8.sp,
                                      color: Colors.grey
                                  ),),
                              ],
                            ),
                          ) : Stack(
                            children: [
                              SizedBox(
                                height: 21.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: min(likedProducts.length, 4),
                                    itemBuilder: (context, index){
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                                        child: CollectionItem(
                                            product: likedProducts[index],
                                            round: 2,
                                            photoOnly: true),
                                      );
                                    }),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushNamed('/productsView', arguments: likedProducts);
                                  },
                                  borderRadius: BorderRadius.circular(5.sp),
                                  highlightColor: theme.secondaryHeaderColor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2.sp)
                                    ),
                                    padding: EdgeInsets.all(2.w),
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
                    ),
                  );
                }
              ),
              SizedBox(height: 5.h),
              pod == null ? Center(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Text('Please sign in to personalize your experience.',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      onPressed: (){
                        box!.signOut();
                      },
                      child: Text('Sign in'),
                    ),
                    SizedBox(height: 3.h),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(thickness: 1,)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text('OR')),
                        Expanded(child: Divider(thickness: 1,))
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          googleSignIn();
                        },
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white
                          ),
                          child:  CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(1.w),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/images/google_icon.png'),
                              ),
                            ),
                          ),),
                        ElevatedButton(onPressed: (){
                          facebookSignIn();
                        },
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white
                          ),
                          child:  CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(1.w),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/images/facebook_icon.png'),
                              ),
                            ),
                          ),),
                        ElevatedButton(onPressed: (){
                          signInWithGoogle(context);
                        },
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white
                          ),
                          child:  CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(1.w),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/images/apple_icon.png'),
                              ),
                            ),
                          ),),
                      ],
                    ),
                  ],
                ),
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 1.h),
                  InkWell(
                    onTap: () {
                      navKey.currentState?.pushNamed('/editAddress');
                    },
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
                              Icon(CupertinoIcons.location_solid, color: Colors.grey,
                              size: 16.sp),
                              SizedBox(width: 2.w,),
                              Text(defAddress == null ? 'No Address' : defAddress!.name,
                                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 12.sp),),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Padding(
                            padding: EdgeInsets.only(left: 1.5.w),
                            child: Text(defAddress == null ? '' : '${defAddress!.address.capitalizeAllWords()}, ${defAddress!.details.capitalizeAllWords()}, ${defAddress!.city.capitalizeAllWords()}, ${defAddress!.country.capitalizeAllWords()}',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp),),
                          ),
                          SizedBox(height: 2.h,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Row(
                              children: [
                                Text(defAddress == null ? 'Add New Address' : 'Change Default Address',
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
                  SizedBox(height: 3.h,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed('/pastOrders');
                    },
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: blueColor.withOpacity(0.3),
                    child: ListTile(
                      iconColor: theme.secondaryHeaderColor,
                      textColor: theme.secondaryHeaderColor,
                      leading: Icon(Icons.receipt),
                      title: Text('Past Orders',  style: TextStyle(fontSize: 9.sp)),
                      trailing: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  Divider(height: 1.h),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed('/editInfo');
                    },
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: theme.textSelectionTheme.selectionColor,
                    child: ListTile(
                      iconColor: theme.secondaryHeaderColor,
                      textColor: theme.secondaryHeaderColor,
                      leading: Icon(CupertinoIcons.person_fill),
                      title: Text('Change Information',  style: TextStyle(fontSize: 9.sp)),
                      trailing: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  Divider(height: 1.h),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed('/phonePage');
                    },
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: theme.textSelectionTheme.selectionColor,
                    child: ListTile(
                      iconColor: theme.secondaryHeaderColor,
                      textColor: theme.secondaryHeaderColor,
                      leading: Icon(CupertinoIcons.phone_fill),
                      title: Text(pod!.phoneNumber == 'null' ? 'Add Phone Number': 'Change Phone Number',  style: TextStyle(fontSize: 9.sp)),
                      trailing: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  _provider == 'password' ? Divider(height: 1.h) : Container(),
                  _provider == 'password' ? InkWell(
                    onTap: (){
                      FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email!);
                      showErrorBar(context, 'An email has been sent with steps to reset password!', good: true);
                    },
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: theme.textSelectionTheme.selectionColor,
                    child: ListTile(
                      iconColor: theme.secondaryHeaderColor,
                      textColor: theme.secondaryHeaderColor,
                      leading: Icon(Icons.key),
                      title: Text('Change Password',  style: TextStyle(fontSize: 9.sp)),
                      trailing: Icon(Icons.chevron_right_rounded),
                    ),
                  ) : Container(),
                  (!_provider.contains('facebook') &&
                      !_provider.contains('google')) ? Divider(height: 1.h) : Container(),
                  (!_provider.contains('facebook') &&
                    !_provider.contains('google')) ? InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: theme.textSelectionTheme.selectionColor,
                    child: ListTile(
                      iconColor: theme.secondaryHeaderColor,
                      textColor: theme.secondaryHeaderColor,
                      leading: Icon(CupertinoIcons.envelope),
                      title: Text( pod!.email == 'null' ? 'Add Email' : 'Change Email', style: TextStyle(fontSize: 9.sp)),
                      trailing: Icon(Icons.chevron_right_rounded),
                    ),
                  ) : Container(),
                  SizedBox(height: 2.h,),
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            ),
                            backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black
                        ),
                        onPressed: () {
                          box!.signOut();
                        },
                        child: Text('Logout')),
                  ),
                  SizedBox(height: 4.h,),
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            )
                        ),
                        onPressed: (){

                        },
                        child: Text('Delete Account', style: TextStyle(color: Colors.red, fontSize: 10.sp),)),
                  ),
                  SizedBox(height: 5.h,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  googleSignIn() async{
    setState(() {
      loading = true;
    });
    final c = await signInWithGoogle(context);

    switch (c){
      case loginState.complete:
        box!.completeUser();
        break;
      case loginState.incomplete:
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
        break;
      case loginState.emailUsed:
        showErrorBar(context, 'This email is already registered through another sign in method.');
        break;
      case loginState.invalid:
        if (FirebaseAuth.instance.currentUser != null) FirebaseAuth.instance.signOut();
        break;
      case loginState.unverifiedEmail:
        break;
    }
    setState(() {
      loading = false;
    });
  }


  facebookSignIn() async{
    setState(() {
      loading = true;
    });
    final c = await signInWithFacebook(context);

    switch (c){
      case loginState.complete:
        box!.completeUser();
        break;
      case loginState.incomplete:
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
        break;
      case loginState.emailUsed:
        showErrorBar(context, 'This email is already registered through another sign in method.');
        break;
      case loginState.invalid:
        if (FirebaseAuth.instance.currentUser != null) box!.signOut();
        break;
      case loginState.unverifiedEmail:
        loginNavKey.currentState?.popAndPushNamed('/verifyEmail');
        break;
    }
    setState(() {
      loading = false;
    });
  }
}
