import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'configurations.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final codeField = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  var emailTimeout = false;
  bool emailVerified = false;
  int secondsUntilTimeout = 60;
  late Timer timer;
  late Timer timer2;
  late BlackBox box;

  sendEmail() async{
    try{
      await user!.sendEmailVerification();
      setState(() {
        emailTimeout = true;
      });
      timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsUntilTimeout <= 0){
          timer.cancel();
          secondsUntilTimeout = 60;
          setState(() {
            emailTimeout = false;
          });
        }else{
          setState(() {
            secondsUntilTimeout--;
          });
        }
      });

    }on FirebaseAuthException catch (e){
      setState(() {
        emailTimeout = false;
      });
      showErrorBar(context, e.message!);
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_){
          verifyEngine();
          FirebaseAuth.instance.authStateChanges().listen((snapshot) {
            if (snapshot == null){
              loginNavKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
            }
          });
        });
    super.initState();
  }

  verifyEngine(){
    sendEmail();
    if (FirebaseAuth.instance.currentUser != null){
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (FirebaseAuth.instance.currentUser != null){
          await FirebaseAuth.instance.currentUser!.reload();
          if(FirebaseAuth.instance.currentUser!.emailVerified) {
            timer.cancel();
            timer2.cancel();
            loginNavKey.currentState?.pushNamedAndRemoveUntil('/incomplete', (Route<dynamic> route) => false);
          }
        }else{
          timer.cancel();
        }

      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 10.h,
              right: 0,
              left: 0,
              child: Center(
                child: SizedBox(
                    width: 70.w,
                    child: Image.asset('assets/images/logo.png')),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Verify Your Email Address',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 1.5.h),
                Text('An email has been sent to ${user!.email},\nplease click on the link and return to the app.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: emailTimeout,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: emailTimeout ? Colors.grey.shade900 : Colors.white,
                            backgroundColor: emailTimeout ? Colors.grey: blueColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0)
                            )
                        ),
                        onPressed:() async {
                          if (user != null){
                            sendEmail();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Resend Email"),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: blueColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0)
                          )
                      ),
                      onPressed: () async {
                        if (user != null){
                          try{
                            timer.cancel();
                            timer2.cancel();

                          }on FirebaseAuthException catch (e){
                            showErrorBar(context, e.message!);
                          }finally{
                            // TODO: fix when error code is 'requires-recent-login'
                            FirebaseAuth.instance.currentUser!.delete();
                            box.signOut();
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Change Email"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                emailTimeout ? Text('Try to resend in ${secondsUntilTimeout} seconds') : SizedBox(height: 2.h)
              ],
            ),
          ],
        ),
      );
  }
}
