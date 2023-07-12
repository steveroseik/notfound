import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {

  TextEditingController emailField = TextEditingController();

  @override
  void dispose() {
    emailField.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            SizedBox(height: 7.h),
            FilledButton(
                onPressed: (){
                  loginNavKey.currentState?.pop();
                },
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.back),
                    Text('Back to login', style: TextStyle(fontSize: 10.sp),),
                  ],
                )),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  SizedBox(
                      width: 70.w,
                      child: Image.asset('assets/images/logo.png')),
                  SizedBox(height: 7.h),
                  SizedBox(
                    height: 30.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailField,
                            decoration: inputDecorationStock(hint: "Email"),
                            style: const TextStyle(fontFamily: '', fontWeight: FontWeight.w600),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if (value == null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),
                          Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.sp)
                                  ),
                                ),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if (emailField.text.isNotEmpty &&
                                      (RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(emailField.text))) {
                                    resetEmail();
                                  }else{
                                    showErrorBar(context, 'Please enter a valid email format!');
                                  }
                                },
                                child: Text('RESET PASSWORD', style: TextStyle(color: Colors.white, fontSize: 10.sp))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetEmail() async{
    try{
      final data = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailField.text).limit(1).get();
      if (data.docs.isNotEmpty){
        if (data.docs.first.data()['provider'] == 'password'){
          showErrorBar(context, 'An email has been with steps to reset password.', good: true);
        }else{
          showErrorBar(context, 'This email is not associated with an email/password credentials account!');
        }
      }else{
        showErrorBar(context, 'No account associated with this email!');
      }
    }catch (e){
      print(e);
    }
  }
}
