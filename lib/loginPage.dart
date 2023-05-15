import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notfound/pinput_theme.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import 'blackBox.dart';
import 'configurations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController emailField = TextEditingController();
  TextEditingController passField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  FocusNode passNode = FocusNode();
  FocusNode firstPin = FocusNode();
  late TabController loginMethodController;
  late AnimationController animationController1;
  late BlackBox box;
  bool showPassField = false;

  @override
  void initState() {
    animationController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    loginMethodController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController1.dispose();
    loginMethodController.dispose();
    emailField.dispose();
    phoneField.dispose();
    passField.dispose();
    firstPin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              TabBar(
                  controller: loginMethodController,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  indicatorWeight: 0.5.sp,
                  labelColor: Colors.black,
                  dividerColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  padding: EdgeInsets.all(5.w),
                  isScrollable: false,
                  tabs:[
                    FittedBox(child: Text('Email')),
                    FittedBox(child: Text('Phone')),
                  ]),
              SizedBox(
                height: 20.h,
                child: TabBarView(
                    controller: loginMethodController,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailField,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecorationStock(hint: "Email"),
                              style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                              onChanged: (text){
                                if (text.length > 4){
                                  if (!animationController1.isCompleted) {
                                    setState(() {
                                      showPassField = true;
                                    });
                                    animationController1.forward();
                                  }
                                }else{
                                  if (animationController1.isCompleted) {
                                    setState(() {
                                      showPassField = false;
                                    });
                                    animationController1.reverse();
                                  }
                                }
                              },
                              onFieldSubmitted: (_) {
                                if (emailField.text.length > 4) passNode.requestFocus();
                              },
                            ),
                            SizedBox(height: 1.h),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(scale: animation, child: child);
                                  },
                                  child: showPassField ? SlideTransition(
                                    key: const Key('passField1'),
                                    position: Tween<Offset>(begin: const Offset(0,-1), end: const Offset(0, 0)).animate(animationController1),
                                    child: FadeTransition(
                                      opacity: animationController1,
                                      child: TextFormField(
                                        controller: passField,
                                        focusNode: passNode,
                                        textInputAction: TextInputAction.next,
                                        obscureText: true,
                                        decoration: inputDecorationStock(label: "Password"),
                                        style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                                        onChanged: (text){
                                        },
                                        onTap: (){

                                        },
                                      ),),
                                  ) : Container(key: const Key('container1'))),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: double.maxFinite,
                              height: 5.h,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.sp)
                                    ),
                                  ),
                                  onPressed: (){
                                  },
                                  child: Text('Login', style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: phoneField,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: inputDecorationStock(hint: "+20 123 345 678"),
                              style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                              onChanged: (text){
                                if (text.length > 4){
                                  if (!animationController1.isCompleted) {
                                    setState(() {
                                      showPassField = true;
                                    });
                                    animationController1.forward();
                                  }
                                }else{
                                  if (animationController1.isCompleted) {
                                    setState(() {
                                      showPassField = false;
                                    });
                                    animationController1.reverse();
                                  }
                                }
                              },
                              onFieldSubmitted: (_){
                                firstPin.requestFocus();
                              },
                            ),
                            SizedBox(height: 1.h),
                            OnlyBottomCursor(node: firstPin),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: 50.w,
                              height: 5.h,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CupertinoColors.extraLightBackgroundGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.sp)
                                    ),
                                  ),
                                  onPressed: (){
                                    firstPin.requestFocus();
                                  },
                                  child: Text('Get code',style: TextStyle(fontSize: 10.sp),)),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
              ),

              SizedBox(height: 5.h),
              const Text('Sign in With'),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    signInWithGoogle();
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
                    signInWithGoogle();
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
                    signInWithGoogle();
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
              Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp)
                      ),
                    ),
                    onPressed: (){
                      navKey.currentState?.pushNamed('/signUp');
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: "Don't Have an Account? ", style: TextStyle(color: Colors.grey)),
                          TextSpan(text: "Sign up"),
                        ]
                      ),
                    )),
              ),
              SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp)
                      ),
                    ),
                    onPressed: (){
                      box.setGuest(true);
                    },
                    child: Text('Sign in Later')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

