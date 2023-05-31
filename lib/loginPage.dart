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
  late BlackBox box;
  bool showPassField = false;
  bool codeSent = false;
  bool loading = true;
  late AnimationController animationController;


  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    loginMethodController = TabController(length: 2, vsync: this);
    postInitiate();
    super.initState();
  }

  @override
  void dispose() {
    loginMethodController.dispose();
    emailField.dispose();
    phoneField.dispose();
    passField.dispose();
    firstPin.dispose();
    passNode.dispose();
    super.dispose();
  }

  postInitiate() async{
    if (FirebaseAuth.instance.currentUser != null){
      //TODO: if user is not validly saved;
      final b = await validateUser();
      if (b){
        box.completeUser();
      }else{
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
      }
    }else{
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return loading ? Container():
    GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              SizedBox(
                  width: 70.w,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(height: 5.h),
              TabBar(
                  controller: loginMethodController,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  indicatorWeight: 0.5.sp,
                  labelColor: Colors.black,
                  dividerColor: Colors.black,
                  labelPadding: EdgeInsets.all(1.w),
                  unselectedLabelColor: Colors.grey,
                  padding: EdgeInsets.all(5.w),
                  splashBorderRadius: BorderRadius.circular(5.sp),
                  isScrollable: false,
                  tabs: const [
                    FittedBox(child: Text('Email')),
                    FittedBox(child: Text('Phone')),
                  ]),
              SizedBox(
                height: 30.h,
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
                              onChanged: (value){
                                if (value != null &&
                                    (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value))) {
                                  if (showPassField){
                                    setState(() {
                                      showPassField = false;
                                    });
                                  }
                                } else {
                                  if (!showPassField){
                                    setState(() {
                                      showPassField = true;
                                    });
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
                              child: Builder(
                                builder: (context) {
                                  return AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return ScaleTransition(scale: animation, child: SlideTransition(
                                          position: Tween<Offset>(begin: const Offset(0,-1), end: const Offset(0, 0)).animate(animation),
                                          child: FadeTransition(
                                            opacity: animation,
                                          child: child),
                                        ));
                                      },
                                      child: showPassField ?  TextFormField(
                                            key: Key('passField1${Random().nextDouble()}'),
                                            controller: passField,
                                            focusNode: passNode,
                                            obscureText: true,
                                            decoration: inputDecorationStock(hint: "Password"),
                                            style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                                            onChanged: (text){
                                            },
                                            onTap: (){
                                            },
                                          ) : Container(key: Key('container1${Random().nextDouble()}')),
                                  );
                                }
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: 45.w,
                              height: 4.h,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blueColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.sp)
                                    ),
                                  ),
                                  onPressed: (){
                                  },
                                  child: Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 13.sp))),
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
                              onFieldSubmitted: (_){
                                firstPin.requestFocus();
                              },
                            ),
                            SizedBox(height: 1.h),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: Builder(
                                  builder: (context) {
                                    return AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return ScaleTransition(scale: animation, child: SlideTransition(
                                          position: Tween<Offset>(begin: const Offset(0,-1), end: const Offset(0, 0)).animate(animation),
                                          child: FadeTransition(
                                              opacity: animation,
                                              child: child),
                                        ));
                                      },
                                      child: codeSent ?  OnlyBottomCursor(node: firstPin) : Container(key: Key('container2${Random().nextDouble()}')),
                                    );
                                  }
                              ),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              height: 15.h,
                              child: Stack(
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    alignment: codeSent ? Alignment.topRight : Alignment.topCenter,
                                    child: AnimatedOpacity(
                                      opacity: codeSent ? 1 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: 40.w,
                                        height: 5.h,
                                        child:ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: blueColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(2.sp)
                                              ),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                codeSent = !codeSent;
                                              });
                                            },
                                            child: Text('VERIFY', style: TextStyle(color: Colors.white, fontSize: 13.sp))),
                                      ),
                                    ),
                                  ),
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                  alignment: codeSent ? Alignment.topLeft : Alignment.topCenter,
                                  child:  AnimatedContainer(
                                    width: 40.w,
                                    height: 5.h,
                                    duration: const Duration(milliseconds: 300),
                                    child:ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: codeSent ? Colors.white : blueColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.sp)
                                          ),
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            codeSent = !codeSent;
                                          });
                                        },
                                        child: Text(codeSent ?'RESEND' : 'GET CODE', style: TextStyle(color: codeSent ?  Colors.black: Colors.white, fontSize: 13.sp))),
                                  )),
                                ],
                              ),
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
              Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/signup');
                      // loginNavKey.currentState?.pushNamed('/signup');
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
                    onPressed: (){
                      box.setGuest(true);
                    },
                    child: Text('Sign in Later', style: TextStyle(fontSize: 10.sp),)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  googleSignIn() async{
    final c = await signInWithGoogle(context);
    if (c != null){
      final b = await validateUser();
      if (b){
        box.completeUser();
      }else{
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
      }
    }
  }
}

