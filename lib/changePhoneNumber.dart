import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/pinput_theme.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';


class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {

  late BlackBox box;
  UserPod? user;

  bool codeSent = false;

  TextEditingController phoneField = TextEditingController();
  TextEditingController extensionField = TextEditingController()..text = '+20';
  TextEditingController pinCodeField = TextEditingController();

  FocusNode firstPin = FocusNode();

  String verifId = '';


  @override
  void dispose() {
    phoneField.dispose();
    extensionField.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    user = box.userPod();
    return SafeArea(child: Scaffold(
      appBar: MyAppBar(context: context, box: box),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            user!.phoneNumber != 'null' ? Text('Current Phone Number',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),) : Container(),
            user!.phoneNumber != 'null' ? Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.all(4.w),
              child: Text(user!.phoneNumber,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
              textAlign: TextAlign.center,),
            ) : Container(),
            Text((user != null && user!.phoneNumber == 'null') ?
            'Add Your Phone Number' : 'Change It To',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(

                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: (){
                            selectCountry();
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: extensionField,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: inputDecorationStock(hint: "+20"),
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                            onFieldSubmitted: (_) async{

                            },
                            onChanged: (value){
                              if (codeSent){
                                setState(() {
                                  codeSent = false;
                                  pinCodeField.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                          flex: 3,
                          child: TextFormField(
                            controller: phoneField,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: inputDecorationStock(hint: "12345789"),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            onChanged: (value){
                              if (codeSent){
                                setState(() {
                                  codeSent = false;
                                  pinCodeField.clear();
                                });
                              }
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              if (!validatePhoneNumber(value)) {
                                return '';
                              }
                              return null;
                            },
                          ))
                    ],
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
                            child: codeSent ?  OnlyBottomCursor(controller: pinCodeField,node: firstPin) : Container(key: Key('con3ner23${Random().nextDouble()}')),
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
                                  onPressed: () async{
                                    confirmCode(strict: user!.provider != 'phone' ? false : true);
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
                                  onPressed: () async{
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (validatePhoneNumber(phoneField.text) && extensionField.text.isNotEmpty){
                                      pinCodeField.clear();
                                      phoneSignIn('${extensionField.text}${phoneField.text}',
                                      strict: user!.provider != 'phone' ? false : true);
                                    }else{
                                      showErrorBar(context, 'Please enter a valid extension and phone number!');
                                    }

                                  },
                                  child: Text(codeSent ?'RESEND' : 'SEND CODE', style: TextStyle(color: codeSent ?  Colors.black: Colors.white, fontSize: 13.sp))),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  selectCountry(){
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 80.h, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(1),
          topRight: Radius.circular(1),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country c) => extensionField.text = '+${c.phoneCode}',
    );
  }

  Future<bool> validateNewPhone({bool strict = false}) async{
    final phone = '${extensionField.text}${phoneField.text}';
    if (user!.phoneNumber == phone){
      showErrorBar(context, 'This is your registered phone number!');
      return false;
    }else{
      if (strict){
        if (!await validatePhoneForCredentials(phone)) {
          showErrorBar(context, 'This phone number is already associated with another account');
          return false;
        }
      }
      return true;
    }
  }

  Future phoneSignIn(String mobile, {bool strict = true}) async{

    final valid = await validateNewPhone(strict: strict);
    if (!valid) return;
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async{
        // nothing
      },
      verificationFailed: (exception){
        print(exception);
        showErrorBar(context, exception.message?? 'no message');
      },
      codeSent: (verificationId, forceResendingToken) async{
        verifId = verificationId;
        setState(() {
          codeSent = true;
        });
        firstPin.requestFocus();
      }, codeAutoRetrievalTimeout: (String verificationId) {
      print('codeAutoRetrievalTimeout : $verificationId');
    },
    );
  }

  confirmCode({bool strict = true}) async{
    try{
      final credential = PhoneAuthProvider.credential(verificationId: verifId, smsCode: pinCodeField.text);

      if (strict){
        await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
      }
      final now = DateTime.now();
      await FirebaseFirestore.instance.doc('users/${FirebaseAuth.instance.currentUser!.uid}').update({
        'phone': '${extensionField.text}${phoneField.text}',
        'lastModified': Timestamp.fromDate(now)
      });
      box.updateUser(phone: '${extensionField.text}${phoneField.text}', lastModified: now);

      await showAlertSheet(context, title: 'Phone Changed Successfully.',
          subtitle: 'Your Account now is assigned with the phone number: ${extensionField.text}${phoneField.text}',
          yesNo: false, confirmBtnText: 'Acknowledge');
      Navigator.of(context).pop();
    }on FirebaseAuthException catch (e){

      if (e.code == 'session-expired'){
        showErrorBar(context, 'Session Expired, Resend a new code.');
      }else if (e.code == 'invalid-verification-code'){
        showErrorBar(context, 'Incorrect Verification Code');
      }else{
        showErrorBar(context, '${e.code}: ${e.message}');
      }

    }
  }

}
