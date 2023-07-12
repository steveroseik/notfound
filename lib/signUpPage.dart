import 'dart:math';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/pinput_theme.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
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
  TextEditingController extensionField = TextEditingController()..text = '+20';
  TextEditingController pinField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TabController signMethodController;
  late BlackBox box;
  FocusNode firstNode = FocusNode();
  late String verifId;
  bool codeSent = false;
  bool loading = false;

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
    box = BlackNotifier.of(context);
    return  GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 7.h),
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
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
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
                          height: 35.h,
                          child: TabBarView(
                              controller: signMethodController,
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
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
                                              signUpAction();
                                            },
                                          ),
                                          SizedBox(height: 2.h),
                                          SizedBox(
                                            width: 45.w,
                                            height: 5.h,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: blueColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(2.sp)
                                                  ),
                                                ),
                                                onPressed: (){
                                                  signUpAction();
                                                },
                                                child: Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 13.sp))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                                      pinField.clear();
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
                                                onFieldSubmitted: (_) async{
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  // if (await validPhoneNumber(phoneField.text)){
                                                  // phoneSignIn(phoneField.text);
                                                  // }else{
                                                  // showErrorBar(context, 'This phone number is associated with another account.');
                                                  // }
                                                },
                                                onChanged: (value){
                                                  if (codeSent){
                                                    setState(() {
                                                      codeSent = false;
                                                      pinField.clear();
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
                                                child: codeSent ?  Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 2.h),
                                                    Text('VERIFICATION CODE',
                                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 10.sp),),
                                                    OnlyBottomCursor(controller: pinField,node: firstNode),
                                                  ],
                                                ) : Container(key: Key('conasdjkt45ez${Random().nextDouble()}')),
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
                                                        confirmCode();
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
                                                        pinField.clear();
                                                        if (validatePhoneNumber(phoneField.text) && extensionField.text.isNotEmpty){
                                                          phoneSignIn('${extensionField.text}${phoneField.text}');
                                                        }else{
                                                          showErrorBar(context, 'Please enter a valid extension and phone number!');
                                                        }
                                                      },
                                                      child: Text(codeSent ?'RESEND' : 'LOGIN', style: TextStyle(color: codeSent ?  Colors.black: Colors.white, fontSize: 13.sp))),
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
                        Spacer(),
                        SafeArea(
                          child: Column(
                            children: [
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            loadingWidget(loading)
          ],
        ),
      ),
    );
  }

  signUpAction() async{
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      loading = true;
    });
    bool? valid = _formKey.currentState?.validate();
    if (valid != null && valid){
      final success = await signUpWithEmail(context, emailField.text, passField.text);
      if (success) loginNavKey.currentState?.popAndPushNamed('/verifyEmail');
    }
    setState(() {
      loading = false;
    });
  }

  googleSignIn() async{
    setState(() {
      loading = true;
    });
    final c = await signInWithGoogle(context);

    switch (c){
      case loginState.complete:
        box.completeUser();
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

  Future phoneSignIn(String mobile) async{

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async{

        final result = await _auth.signInWithCredential(credential);
        await validateUserCredentials(context, result);
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
        firstNode.requestFocus();
      }, codeAutoRetrievalTimeout: (String verificationId) {
      print('codeAutoRetrievalTimeout : $verificationId');
    },
    );
  }

  confirmCode() async{
    final c = await signInWithPhone(context, verifId, pinField.text);
    switch (c){
      case loginState.complete:
        box.completeUser();
        break;
      case loginState.incomplete:
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
        break;
      case loginState.emailUsed:
        showErrorBar(context, 'This phone number is associated with another account.');
        break;
      case loginState.invalid:
        if (FirebaseAuth.instance.currentUser != null) box.signOut();
        break;
      case loginState.unverifiedEmail:
        print('This should not happen, please report this error: UNV_EML_LOGIN');
        break;
    }
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

}
