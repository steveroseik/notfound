import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';



const blueColor = Color(0xFF001BA0);
const mediumGreyColor = Color(0xFFF3F3F3);
const darkGreyColor = Color(0xFF919191);

class Styles {

  static MaterialColor lightSwatch = const MaterialColor(
    0xFFF3F3F3,
    <int, Color>{
      50: mediumGreyColor,
      100: mediumGreyColor,
      200: mediumGreyColor,
      300: mediumGreyColor,
      400: mediumGreyColor,
      500: mediumGreyColor,
      600: mediumGreyColor,
      700: mediumGreyColor,
      800: mediumGreyColor,
      900: mediumGreyColor,
    },
  );

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: 'avenir',
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 14.sp),
        bodyMedium: TextStyle(fontSize: 12.sp),
        bodySmall: TextStyle(fontSize: 10.sp),
        labelLarge: TextStyle(fontSize: 14.sp),
        labelMedium: TextStyle(fontSize: 12.sp),
        labelSmall: TextStyle(fontSize: 10.sp),
      ),
      primaryColor: isDarkTheme ? Colors.black : mediumGreyColor,
      secondaryHeaderColor: isDarkTheme ? Colors.white : Colors.black,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) :
      darkGreyColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xff3B3B3B)) :
            MaterialStateProperty.all<Color>(darkGreyColor),
            foregroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xffF1F5FB)) :
            MaterialStateProperty.all<Color>(darkGreyColor)
        ),
      ),
      hintColor: isDarkTheme ? Color(0xff280C0B) :
      darkGreyColor,

      highlightColor: isDarkTheme ? Color(0xff372901) :
      darkGreyColor,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) :
      Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : darkGreyColor,
      disabledColor: Colors.grey.shade500,
      cardColor: isDarkTheme ? Color(0xFF151515) :
      mediumGreyColor,
      canvasColor: isDarkTheme ? Colors.black :
      mediumGreyColor,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ), colorScheme: ColorScheme.fromSwatch(
        primarySwatch: isDarkTheme ? Colors.grey :
        lightSwatch,
        brightness: isDarkTheme ? Brightness.dark :
        Brightness.light),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : blueColor.withOpacity(0.5),
          selectionHandleColor: isDarkTheme ? darkGreyColor : Colors.black,
          cursorColor: isDarkTheme ? mediumGreyColor : blueColor),
    );

  }
}

class CreditCardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}


Future<bool> isBuildFinished(ValueNotifier v) async{

  Completer<bool> completer = Completer();
  v.addListener(() async{
    completer.complete(v.value);
  });
  return completer.future;

}

InputDecoration inputDecorationStock({String? hint, String? label}){
  return InputDecoration(
    errorStyle: const TextStyle(height: 0),
    contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1.sp)),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1.sp),
        borderSide: const BorderSide(color: Colors.white)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1.sp),
        borderSide: const BorderSide(color: Colors.red)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1.sp),
        borderSide: const BorderSide(color: CupertinoColors.white)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: CupertinoColors.white),
        borderRadius: BorderRadius.circular(2.sp)),
    filled: true,
    fillColor: CupertinoColors.white,
    hintStyle: TextStyle(color: Colors.grey, fontFamily: '', fontSize: 10.sp, fontWeight: FontWeight.w600),
    labelStyle: TextStyle(color: Colors.grey, fontFamily: '', fontSize: 10.sp, fontWeight: FontWeight.w600),
    hintText: hint,
    labelText: label
  );
}


Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? user = await GoogleSignIn(
      scopes: <String>['email'],
    ).signIn();

    if (user == null) {
      // User canceled the sign-in process
      return null;
    }

    final GoogleSignInAuthentication auth = await user.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credentials);
  } catch (e) {
    showErrorBar(context, 'Error signing in with Google: $e');
    return null;
  }

}


signUpWithEmail(BuildContext context, String em, String pw) async{
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: em, password: pw);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        showErrorBar(context, 'The email address is already in use.');
        break;

      case 'invalid-email':
        showErrorBar(context, 'The provided email address is invalid.');
        break;

      case 'operation-not-allowed':
        showErrorBar(context, "You're not allowed to do this action.");
        break;

      case 'weak-password':
        showErrorBar(context, 'The provided password is too weak.');
        break;

      case 'too-many-requests':
        showErrorBar(
            context, 'Too many sign-up requests. Please try again later.');
        break;

      case 'network-request-failed':
        showErrorBar(context,
            'A network error occurred. Please check your internet connection.');
        break;

      default:
        showErrorBar(context,
            'An unknown error occurred. If serious please report.');
    }
  }
}

Future<bool> validateUser() async{
  final pref = await SharedPreferences.getInstance();
  if (FirebaseAuth.instance.currentUser == null){
    if (pref.getBool('completeUser') != null && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return false;
  }

  final uEmail = FirebaseAuth.instance.currentUser!.email;

  try{
    final doc = await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: uEmail).limit(1).get();

    if (doc.docs.isNotEmpty) {

      pref.setBool('completeUser', true);
      return true;
    }
    if (pref.getBool('completeUser') != null && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return false;

  }on FirebaseException catch (e){
    print(e.message);
    if (pref.getBool('completeUser') != null && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return false;
  }
}

signUpUserData(String fname, String lname, DateTime bday, bool isMale){

}



