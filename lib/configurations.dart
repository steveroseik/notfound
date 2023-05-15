import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';



class Styles {

  static MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 10),
        labelMedium: TextStyle(fontSize: 8),
        labelSmall: TextStyle(fontSize: 6),
      ),
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xff3B3B3B)) : MaterialStateProperty.all<Color>(Color(0xffF1F5FB)),
            foregroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xffF1F5FB)) : MaterialStateProperty.all<Color>(Color(0xff3B3B3B))
        ),
      ),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey.shade500,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.white,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ), colorScheme: ColorScheme.fromSwatch(
        primarySwatch: isDarkTheme ? Colors.grey : white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light).copyWith(
        background: isDarkTheme ? Colors.black : const Color(0xffF1F5FB)),
      textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
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
    contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.sp),
        borderSide: const BorderSide(color: CupertinoColors.extraLightBackgroundGray)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.sp),
        borderSide: const BorderSide(color: CupertinoColors.extraLightBackgroundGray)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.sp)),
    filled: true,
    fillColor: CupertinoColors.extraLightBackgroundGray,
    hintStyle: TextStyle(color: Colors.grey, fontFamily: '', fontSize: 10.sp, fontWeight: FontWeight.w600),
    labelStyle: TextStyle(color: Colors.grey, fontFamily: '', fontSize: 10.sp, fontWeight: FontWeight.w600),
    hintText: hint,
    labelText: label
  );
}


signInWithGoogle() async{
  final GoogleSignInAccount? user = await GoogleSignIn(
    scopes: <String>['email']).signIn();

  final GoogleSignInAuthentication auth = await
  user!.authentication;

  final credentials = GoogleAuthProvider.credential(
    accessToken: auth.accessToken,
    idToken: auth.idToken
  );

  return await FirebaseAuth.instance.signInWithCredential(credentials);
}
 Future<String> signupWithEmail(String email, String pass) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: pass);

    return 'good';
  } on FirebaseAuthException catch (e) {
    return e.message!;
  }

}
