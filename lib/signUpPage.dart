import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/pinput_theme.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'configurations.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin{
  TextEditingController emailField = TextEditingController();
  TextEditingController passField = TextEditingController();
  TextEditingController passField2 = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TabController signMethodController;
  FocusNode firstNode = FocusNode();
  bool codeSent = false;

  @override
  void initState() {
    signMethodController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    signMethodController.dispose();
    emailField.dispose();
    phoneField.dispose();
    passField.dispose();
    passField2.dispose();
    firstNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 5.h),
              FilledButton(
                  onPressed: (){
                    loginNavKey.currentState?.pop();
                  },
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.back),
                      Text('Back to login', style: TextStyle(fontSize: 10.sp),),
                    ],
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        SizedBox(
                            width: 70.w,
                            child: Image.asset('assets/images/logo.png')),
                        SizedBox(height: 5.h),
                        TabBar(
                            controller: signMethodController,
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
                              controller: signMethodController,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 1.h),
                                        TextFormField(
                                          controller: emailField,
                                          textInputAction: TextInputAction.next,
                                          decoration: inputDecorationStock(label: "Email"),
                                          style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value != null &&
                                                (!RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(value))) {
                                              return '';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 1.h),
                                        TextFormField(
                                          controller: passField,
                                          textInputAction: TextInputAction.next,
                                          obscureText: true,
                                          decoration: inputDecorationStock(label: "Password"),
                                          style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value){
                                            if (value != null && value.length < 6) return '';
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 1.h),
                                        TextFormField(
                                          controller: passField2,
                                          textInputAction: TextInputAction.done,
                                          obscureText: true,
                                          decoration: inputDecorationStock(label: "Confirm Password"),
                                          style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value){
                                            if (value != passField.text) return '';
                                            return null;
                                          },
                                          onFieldSubmitted: (value){
                                            bool? valid = _formKey.currentState?.validate();
                                            if (valid != null && valid){
                                              signUpWithEmail(context, emailField.text, passField.text);
                                            }
                                          },
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
                                                bool? valid = _formKey.currentState?.validate();
                                                if (valid != null && valid){
                                                  signUpWithEmail(context, emailField.text, passField.text);
                                                }
                                              },
                                              child: Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 13.sp))),
                                        ),
                                      ],
                                    ),
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
                                          firstNode.requestFocus();
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
                                                child: codeSent ?  OnlyBottomCursor(node: firstNode) : Container(key: const Key('container@signup}')),
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
                                    child: Image.asset('assets/images/google_icon.png'),
                                  ),
                                ),
                              ),),
                            ElevatedButton(
                              onPressed: (){
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
}
