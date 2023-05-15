import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'configurations.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset('assets/images/logo.png'),
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
        ],
      ),
    );
  }
}
