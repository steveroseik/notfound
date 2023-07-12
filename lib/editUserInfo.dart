import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'configurations.dart';
import 'objects.dart';


class EditUserInfo extends StatefulWidget {
  const EditUserInfo({Key? key}) : super(key: key);

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  bool isMale = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  DateTime bDate = DateTime.now();
  late BlackBox box;
  late UserPod user;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_){
      FirebaseAuth.instance.authStateChanges().listen((snapshot) {
        if (snapshot == null){
          loginNavKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
        }
      });
      final tempUser = box.userPod();
      if (tempUser != null){
        user = tempUser;
        firstName.text = tempUser.firstName;
        lastName.text = tempUser.lastName;
        bDate = tempUser.birthdate;
        birthdate.text = '${bDate.day}/${bDate.month}/${bDate.year}';
        isMale = tempUser.isMale;
        setState(() {});
      }else{
        Navigator.of(context).pop();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(context: context, box: box, showCart: false, restricted: true),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Align(alignment: Alignment.bottomLeft, child: Text('Edit Your Info',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),)),
                  SizedBox(height: 4.h),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: firstName,
                    decoration: inputDecorationStock(label: 'First Name'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text){
                      if (text != null && text.length < 2) return '';
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: lastName,
                    decoration: inputDecorationStock(label: 'Last Name'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text){
                      if (text != null && text.length < 2) return '';
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () => _showDatePicker(),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: birthdate,
                      enabled: false,
                      decoration:inputDecorationStock(label: 'Birthdate'),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    height: 5.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                isMale = true;
                              });
                            },
                            child: AnimatedContainer(
                              padding: EdgeInsets.symmetric(vertical: 1.h),

                              decoration: BoxDecoration(
                                  gradient: isMale ? LinearGradient(colors: [blueColor, Colors.grey.shade300]) :
                                  LinearGradient(colors: [Colors.white, Colors.grey.shade300])
                              ),
                              duration: const Duration(milliseconds: 300),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.man, color: blueColor),
                                  Text('Male',
                                      style: TextStyle(
                                          fontWeight: isMale ? FontWeight.w600 : null,
                                          color: !isMale ? Colors.black : Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                isMale = false;
                              });
                            },
                            child: AnimatedContainer(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              decoration: BoxDecoration(
                                  gradient: !isMale ? LinearGradient(colors: [Colors.grey.shade300, blueColor]) :
                                  LinearGradient(colors: [Colors.grey.shade300, Colors.white])
                              ),
                              duration: const Duration(milliseconds: 300),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.woman, color: Colors.purple),
                                  Text('Female',
                                      style: TextStyle(
                                          fontWeight: !isMale ? FontWeight.w600 : null,
                                          color: isMale ? Colors.black : Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 80.w,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.sp)
                          ),
                        ),
                        onPressed: () {
                          updateUser();
                        },
                        child: Text('UPDATE',
                          style: TextStyle(color: Colors.white),)),
                  ),
                  SizedBox(height: 5.h)
                ],
              ),
            ),
            loadingWidget(loading)
          ],
        ),
      ),
    );
  }

  void updateUser() async{
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      loading = true;
    });
    if (firstName.text.length >=2 &&
        lastName.text.length >= 2 &&
        birthdate.text.isNotEmpty){
      final success = await box.updateUserInfo({
        'fname': firstName.text.capitalize(),
        'lname': lastName.text.capitalize(),
        'birthdate': Timestamp.fromDate(bDate),
        'isMale': isMale
      });
      if (!success){
        showErrorBar(context, 'Something went wrong!');
      }

      Navigator.of(context).pop();
    }else{
      showErrorBar(context, 'Please complete your info.');
    }
    setState(() {
      loading = true;
    });
  }

  void _showDatePicker() {
    final now = DateTime.now();
    DateTime newDate = DateTime.now();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp),topLeft: Radius.circular(5.sp)),
                color: Colors.white
            ),
            height: MediaQuery
                .of(context)
                .copyWith()
                .size
                .height * 0.35,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp))
                      ),
                      child: Text('Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop(newDate);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.sp)),
                      ),
                      child: Text('Done',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 10.sp,
                        ),),
                    ),
                  ],
                ),
                Flexible(
                  flex: 2,
                  child:CupertinoDatePicker(
                    initialDateTime: now,
                    maximumDate: now,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        newDate = newDateTime;
                      });
                    },
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: false,
                    backgroundColor: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          );
        }).then((value) {
      if (value != null){
        setState(() {
          bDate = value;
          birthdate.text = '${bDate.day}/${bDate.month}/${bDate.year}';
        });
      }
    });
  }
}
