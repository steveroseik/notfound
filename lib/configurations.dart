import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:slugid/slugid.dart';

import 'objects.dart';



const blueColor = Color(0xFF001BA0);
const mediumGreyColor = Color(0xFFF3F3F3);
const darkGreyColor = Color(0xFF919191);

enum loginState {complete, incomplete, emailUsed, unverifiedEmail, invalid}
enum loginProvider {email, facebook, google, apple, phone, empty}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeAllWords() {
    final words = split(' ');
    final capitalizedWords = words.map((word) => word.capitalize());
    return capitalizedWords.join(' ');
  }
}

String extractHexCode(String input) {
  // Remove leading and trailing whitespace
  final trimmedInput = input.trim();

  // Remove '#' if present
  final withoutHash = trimmedInput.startsWith('#')
      ? trimmedInput.substring(1)
      : trimmedInput;

  // Remove '\t' if present
  final withoutTab = withoutHash.replaceAll('\t', '');

  // Return the result
  return withoutTab;
}

Color hexToColor(String hexCode) {

  final code = extractHexCode(hexCode);
  // Parse the hex code as an integer
  final hexValue = int.parse(code, radix: 16);

  // Add the alpha value (0xFF) to the hex value
  final argbValue = 0xFF000000 + hexValue;

  // Create and return the Color object
  return Color(argbValue);
}

class AddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    // Perform your formatting logic
    newText = newText.replaceAll(RegExp(r'[^a-zA-Z0-9\s\.,-]'), '');

    // Adjust the selection if needed
    if (newSelection.start > newText.length) {
      newSelection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

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
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      secondaryHeaderColor: isDarkTheme ? Colors.white : Colors.black,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) :
      darkGreyColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xff3B3B3B)) :
            MaterialStateProperty.all<Color>(Colors.black),
            foregroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xffF1F5FB)) :
            MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.6)),
        ),
      ),
      hintColor: isDarkTheme ? Color(0xff280C0B) :
      darkGreyColor,

      highlightColor: isDarkTheme ? Color(0xff372901) :
      darkGreyColor,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) :
      Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : darkGreyColor,
      disabledColor: Colors.grey.shade100,
      cardColor: isDarkTheme ? Color(0xFF151515) :
      Colors.white,
      canvasColor: isDarkTheme ? Colors.black :
      mediumGreyColor,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.dark()),
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

Future<loginState> signInWithEmail(BuildContext context, String em, String pw) async {

  loginState state = loginState.invalid;
  try{
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: em, password: pw);
    state = await validateUserCredentials(context, cred);
  }on FirebaseAuthException catch (e){
    switch (e.code) {
      case 'user-not-found':
        showErrorBar(context, 'User not found');
        break;
      case 'wrong-password':
        showErrorBar(context, 'Wrong password');
        break;
      case 'invalid-email':
        showErrorBar(context, 'Invalid email');
        break;
      case 'network-request-failed':
        showErrorBar(context,
            'A network error occurred. Please check your internet connection.');
        break;
      default:
        showErrorBar(context, 'An error occurred');
        break;
    }
  }
  return state;
}

 Future<loginState> signInWithGoogle(BuildContext context) async {
  loginState state = loginState.invalid;
  try {
    final GoogleSignInAccount? user = await GoogleSignIn(
      scopes: <String>['email'],
    ).signIn();

    if (user == null) {
      // User canceled the sign-in process
      return state;
    }

    final GoogleSignInAuthentication auth = await user.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final loggedUser = await FirebaseAuth.instance.signInWithCredential(credentials);

    state = await validateUserCredentials(context, loggedUser);
  } catch (e) {
    state = loginState.invalid;
    showErrorBar(context, 'Error signing in with Google: $e');
  }

  return state;
}


Future<bool> signUpWithEmail(BuildContext context, String em, String pw) async{
  bool success = false;
  try {
    final newEmail = await validateEmailAtSignup(em);
    if (!newEmail) {
      showErrorBar(context, 'The email address is already registered.');
      return false;
    }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: em, password: pw);
    success = true;
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
  return success;

}

String? getFbEmail(UserCredential cred){
  if (cred.user!.providerData.length > 1){
    for (int i = 0; i < cred.user!.providerData.length; i++){
      if (cred.user!.providerData[i].providerId == 'facebook.com') return cred.user!.providerData[i].email!;
    }
    return null;
  }else{
    return cred.user!.providerData.first.email!;
  }
}

String? getFbEmailExt(User cred){
  if (cred.providerData.length > 1){
    for (int i = 0; i < cred.providerData.length; i++){
      if (cred.providerData[i].providerId == 'facebook.com') return cred.providerData[i].email!;
    }
    return null;
  }else{
    return cred.providerData.first.email!;
  }
}
String? getFbName(UserCredential cred){
  if (cred.user!.providerData.length > 1){
    for (int i = 0; i < cred.user!.providerData.length; i++){
      if (cred.user!.providerData[i].providerId == 'facebook.com') return cred.user!.providerData[i].email!;
    }
    return null;
  }else{
    return cred.user!.providerData.first.email!;
  }
}

Future<bool> validatePhoneForCredentials(String phone) async{
  try{
    final resp = await FirebaseFirestore.instance.collection('users').where('phone', isEqualTo: phone).get();
    if (resp.docs.isEmpty) return true;
    for (var doc in resp.docs){
      print('${doc.data()}');
      if (doc.data()['provider'].contains('phone')) return false;
    }
    return true;
  }catch (e){
    print('phoneChangeVerifError: $e');
    return false;
  }
}

Future<loginState> validateUserCredentials(BuildContext context, UserCredential cred, {bool? fb, bool? phone}) async{

  final email = (fb?? false) ? getFbEmail(cred) : cred.user!.email;
  final uid = cred.user!.uid;
  BlackBox box = BlackNotifier.of(context);
  final prefs = await SharedPreferences.getInstance();

  loginState state = loginState.invalid;
  try{
    late final req;
    if (phone?? false){
      req = await FirebaseFirestore.instance.collection('users')
          .where('phone', isEqualTo: cred.user!.phoneNumber!).where('provider', isEqualTo: 'phone')
          .limit(1).get();
    }else{
      req = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: email)
          .limit(1).get();
    }

    if (req.docs.isNotEmpty) {
      if (req.docs.first.id == uid){

        state = loginState.complete;
        box.setUserInfo(req.docs.first.data());
        prefs.setBool('completeUser', true);
      }else{
        await FirebaseAuth.instance.currentUser!.delete();
        state = loginState.emailUsed;
      }
    }else{
      if (cred.user!.emailVerified){
        state = loginState.incomplete;
      }else{
        if (cred.user!.providerData.first.providerId == 'facebook.com' ||
            cred.user!.providerData.first.providerId == 'phone'){
          // facebook login
          state = loginState.incomplete;
        }else{
          state = loginState.unverifiedEmail;
        }

      }

    }
  }on FirebaseException catch(e){
    print(e.message);
  }
  return state;
}

Future<bool> validateEmailAtSignup(String email) async{
  bool success = false;
  try{
    final req = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (req.docs.isEmpty){
      success = true;
    }
  }on FirebaseException catch (e){
    print(e.message);
  }
  return success;
}


Future<bool?> validateUser(BlackBox box) async{
  final pref = await SharedPreferences.getInstance();
  if (FirebaseAuth.instance.currentUser == null){
    if (pref.containsKey('completeUser') && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return false;
  }

  try{
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists){
      box.setUserInfo(doc.data()!);
      pref.setBool('completeUser', true);
      return true;
    }
    if (pref.containsKey('completeUser') && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return false;

  }on FirebaseException catch (e){
    print(e.message);
    if (pref.getBool('completeUser') != null && pref.getBool('completeUser')!){
      pref.setBool('completeUser', false);
    }
    return null;
  }
}

Future<loginState> signInWithPhone(BuildContext context, String verifId, String code) async{
  loginState c = loginState.invalid;
  try{
    final credential = PhoneAuthProvider.credential(verificationId: verifId, smsCode: code);

    final result = await FirebaseAuth.instance.signInWithCredential(credential);

    c = await validateUserCredentials(context, result, phone: true);
  }on FirebaseAuthException catch (e){
   if (e.code == 'session-expired'){
     showErrorBar(context, 'Session Expired, Resend a new code.');
   }else{
     showErrorBar(context, 'Incorrect Verification Code');
   }

  }
  return c;
}

Future<UserPod?> signUpUserData(String fname, String lname, DateTime bday, bool isMale) async{
  final user = FirebaseAuth.instance.currentUser!;

  final email = (user.providerData.first.providerId.contains('facebook')) ?
                user.providerData.first.email : user.email;
  try{
    final g = await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      "id": user.uid,
      "email": email?? "null",
      "provider": user.providerData.first.providerId,
      "fname": fname,
      "lname": lname,
      "phone": user.phoneNumber?? "null",
      "birthdate": Timestamp.fromMillisecondsSinceEpoch(bday.millisecondsSinceEpoch),
      "isMale": isMale,
      "created_at": FieldValue.serverTimestamp(),
      "lastModified": FieldValue.serverTimestamp()
    });
    final doc = await FirebaseFirestore.instance.doc('users/${user.uid}').get();
    return UserPod.fromShot(doc.data()!);

  }on FirebaseException catch (e){
    print(e.message);
  }
  return null;
}

Future<loginState> signInWithFacebook(BuildContext context) async {
  loginState state = loginState.invalid;
  try{
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.cancelled) {
      return state;
    }

    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);


    final cred = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    state = await validateUserCredentials(context, cred, fb: true);

  }catch (e){
    showErrorBar(context, e.toString());
    state = loginState.invalid;
  }
  return state;
}
 Future createOrderPayment(BlackBox box, {bool cash = false, bool fullReceipt = false}) async{
  final user = FirebaseAuth.instance.currentUser;
  if (user != null){
    try{
     final g = await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'type': cash ? 'CASH' : 'CARD',
        'items': box.cartToReceipt(),
        'amount': box.cartTotalPrice('EGP'),
        'state': cash ? 'SUCCESSFUL' : 'UNPAID',
        'createdAt': Timestamp.fromDate(DateTime.now())
      });

     final fRec = receiptFromShot((await g.get()));
     box.addNewReceipt(fRec);


     if (fullReceipt) return fRec;
     return g.id;
    }on FirebaseException catch (e){
      print('${e.code} ${e.message}');
      return null;
    }
  }else{
    //TODO: ensure login, user is not valid
    return null;
  }

}
Future<void> updateOrderPayment(String pid) async {
  const maxRetries = 3;
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(pid).update({
        'state': 'SUCCESSFUL'
      });
      // Update successful, exit the loop
      return;
    } catch (e) {
      print('Failed to update Firebase doc: $e');
      // Increment the retry count
      retryCount++;
      // Delay before the next retry (e.g., 1 second)
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  print('Max retries exceeded. Failed to update Firebase doc.');
}

bool validatePhoneNumber(String phoneNumber) {
  // Regular expression pattern for phone number validation
  String pattern = r'^\+?(\d{1,3})?[-.\s]?(\d{1,3})[-.\s]?(\d{3})[-.\s]?(\d{4,6})$';

  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}

Future<bool> validPhoneNumber(String number) async{
  try{
    final data = await FirebaseFirestore.instance.collection('users').where('phone', isEqualTo: number).get();
    if (data.docs.isEmpty) return true;
  }on FirebaseAuthException catch (e){
    print(e);
  }
  return false;
}


Future<T> retryAsyncFunction<T>(Future<T> Function() asyncFunction, {int maxRetries = 3, Duration retryDelay = const Duration(seconds: 1)}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      return await asyncFunction();
    } catch (e) {
      print('Retry failed: $e');
      retryCount++;
      await Future.delayed(retryDelay);
    }
  }

  throw Exception('Max retries exceeded. Failed to complete operation.');
}


class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Define the number of teeth
    final int numberOfTeeth = 50;

    // Calculate the width of each tooth
    final double toothWidth = size.width / numberOfTeeth;

    // Calculate the height of each tooth
    final double toothHeight = size.width / numberOfTeeth;

    // Calculate the height of the triangular blending portion
    final double blendHeight = toothHeight / 2;

    // Start building the path
    path.moveTo(0, blendHeight);

    for (int i = 0; i < numberOfTeeth; i++) {
      final double startX = i * toothWidth;
      final double endX = (i + 1) * toothWidth;
      final double middleX = startX + toothWidth * 0.5;

      path.lineTo(startX, blendHeight);
      path.lineTo(middleX, 0);
      path.lineTo(endX, blendHeight);
    }

    path.lineTo(size.width, blendHeight);
    path.lineTo(size.width, size.height - blendHeight);

    for (int i = numberOfTeeth - 1; i >= 0; i--) {
      final double startX = i * toothWidth;
      final double endX = (i + 1) * toothWidth;
      final double middleX = startX + toothWidth * 0.5;

      path.lineTo(endX, size.height - blendHeight);
      path.lineTo(middleX, size.height);
      path.lineTo(startX, size.height - blendHeight);
    }

    path.lineTo(0, size.height - blendHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}


Future<bool> showAlertSheet(BuildContext context,
{
  String title = "New Alert",
  String subtitle = "This is the subtitle",
  String? smallMessage,
  bool yesNo = true,
  cancelBtnText = 'Cancel',
  confirmBtnText = 'Confirm'}) async{
  var resp = false;
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
          color: Colors.white,
          height: 30.h,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp)),
                SizedBox(height: 3.h,),
                Text(subtitle,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp)),
                SizedBox(height: 2.h,),
                smallMessage != null ? Text(smallMessage,
                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade700),)
                  : Container(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    yesNo ? Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: CupertinoColors.extraLightBackgroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            )
                        ),
                        onPressed:  () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(cancelBtnText, style: const TextStyle(color: Colors.red)),
                      ),
                    ) : Container(),
                    yesNo ? SizedBox(width: 4.w) : Container(),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: blueColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.sp)
                            )
                        ),
                        onPressed:  () {
                          Navigator.of(context).pop(true);
                        },
                        child: FittedBox(child: Text(confirmBtnText, style: const TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
  ).then((value){
    if (value != null && value) {
      resp = true;
    }else{
      resp = false;
    }
  });
  return resp;
}



