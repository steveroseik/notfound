import 'dart:math';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';
import 'package:notfound/pinput_theme.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'api_lib.dart';
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
  TextEditingController extensionField = TextEditingController();
  TextEditingController pinCodeField = TextEditingController();

  FocusNode passNode = FocusNode();
  FocusNode firstPin = FocusNode();
  late TabController loginMethodController;
  late BlackBox box;
  bool showPassField = false;
  bool codeSent = false;
  bool loading = true;
  bool isStart = true;
  late AnimationController animationController;
  late String verifId;


  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    loginMethodController = TabController(length: 2, vsync: this);

   WidgetsBinding.instance.addPostFrameCallback((timeStamp) => postInitiate());
   extensionField.text = '+20';
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
    extensionField.dispose();
    super.dispose();
  }

  postInitiate() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      if (user.emailVerified){
        //TODO: if user is not validly saved
        final b = await validateUser(box);
        if (b == null) {
          box.signOut();
          return;
        }
        if (b){
          box.completeUser();
        }else{
          loginNavKey.currentState?.popAndPushNamed('/incomplete');
        }
      }else{
        if (user.providerData.first.providerId == 'facebook.com'){
          // facebook login
          final b = await validateUser(box);
          if (b == null) {
            box.signOut();
            return null;
          }
          if (b){
            box.completeUser();
          }else{
            loginNavKey.currentState?.popAndPushNamed('/incomplete');
          }
        }else if (user.providerData.first.providerId == 'phone'){
          if (user.phoneNumber != null){
            final b = await validateUser(box);
            if (b == null) {
              box.signOut();
              return null;
            }
            if (b){
              box.completeUser();
            }else{
              loginNavKey.currentState?.popAndPushNamed('/incomplete');
            }
          }else{
            box.signOut();
          }

        }else{
          loginNavKey.currentState?.popAndPushNamed('/verifyEmail');
        }

      }

    }else{
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('guest') &&
      prefs.getBool('guest')!) box.setGuest(true);
      setState(() {
        loading = false;
      });
    }
    isStart = false;
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
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
                                          passField.clear();
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

                                                onFieldSubmitted: (_){
                                                  emailSignIn();
                                                },
                                              ) : Container(key: Key('container1${Random().nextDouble()}')),
                                      );
                                    }
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(3.sp),
                                      highlightColor: blueColor.withOpacity(0.4),
                                      onTap: (){
                                        loginNavKey.currentState?.pushNamed('/forgot');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 1.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3.sp),
                                        ),
                                        child: Text('Forgot Password',
                                          style: TextStyle(fontSize: 10.sp, decoration: TextDecoration.underline),
                                          textAlign: TextAlign.left,),
                                      ),
                                    )
                                  ],
                                ),
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
                                        emailSignIn();
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
                                          child: codeSent ?  OnlyBottomCursor(controller: pinCodeField,node: firstPin) : Container(key: Key('container2${Random().nextDouble()}')),
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
                                              if (validatePhoneNumber(phoneField.text) && extensionField.text.isNotEmpty){
                                                pinCodeField.clear();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: Divider(thickness: 1,)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text('SIGN IN WITH', style: TextStyle(fontSize: 10.sp),)),
                      const Expanded(child: Divider(thickness: 1,))
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
                        onPressed: () async{
                          box.setGuest(true);
                          // FirebaseAuth.instance.signOut();
                        },
                        child: Text('Sign in Later', style: TextStyle(fontSize: 10.sp),)),
                  ),
                ],
              ),
            ),
            loadingWidget(loading, opacity: isStart ? 1 : null)
          ],
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

  emailSignIn() async {
    if (passField.length < 6){
      showErrorBar(context, 'Complete your sign in credentials');
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      loading = true;
    });
    final c = await signInWithEmail(context, emailField.text, passField.text);
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
        if (FirebaseAuth.instance.currentUser != null) box.signOut();
        break;
      case loginState.unverifiedEmail:
        loginNavKey.currentState?.popAndPushNamed('/verifyEmail');
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
        box.completeUser();
        break;
      case loginState.incomplete:
        loginNavKey.currentState?.popAndPushNamed('/incomplete');
        break;
      case loginState.emailUsed:
        showErrorBar(context, 'This email is already registered through another sign in method.');
        break;
      case loginState.invalid:
        if (FirebaseAuth.instance.currentUser != null) box.signOut();
        break;
      case loginState.unverifiedEmail:
        loginNavKey.currentState?.popAndPushNamed('/verifyEmail');
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
          firstPin.requestFocus();
        }, codeAutoRetrievalTimeout: (String verificationId) {
      print('codeAutoRetrievalTimeout : $verificationId');
      },
    );
  }

  confirmCode() async{
    final c = await signInWithPhone(context, verifId, pinCodeField.text);
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

