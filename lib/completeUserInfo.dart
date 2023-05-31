import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:sizer/sizer.dart';

import 'configurations.dart';


class CompleteUserInfo extends StatefulWidget {
  const CompleteUserInfo({Key? key}) : super(key: key);

  @override
  State<CompleteUserInfo> createState() => _CompleteUserInfoState();
}

class _CompleteUserInfoState extends State<CompleteUserInfo> {
  bool isMale = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  DateTime bDate = DateTime.now();
  late BlackBox box;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser!;
    if (user.displayName != null){
      firstName.text = user.displayName!.split(' ').first;
      lastName.text = user.displayName!.split(' ').last;
    }
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
        appBar: AppBar(
          title: SizedBox(
            width: double.infinity,
            height: 8.h,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 30.w,
                    child: AspectRatio(aspectRatio:8/30,
                        child: Image(image: AssetImage('assets/images/logo.png'))),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Align(alignment: Alignment.bottomLeft, child: Text('Complete Your Signup',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),)),
              SizedBox(height: 4.h),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: firstName,
                decoration: inputDecorationStock(label: 'First Name'),
                onChanged: (_){
                },
                onTap: (){

                },
              ),
              SizedBox(height: 1.h),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: lastName,
                decoration: inputDecorationStock(label: 'Last Name'),
                onChanged: (_){
                },
                onTap: (){

                },
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () => _showDatePicker(),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
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
              SizedBox(height: 5.h),
              SizedBox(
                width: 80.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.sp)
                      ),
                    ),
                    onPressed: (){},
                    child: Text('CONTINUE',
                      style: TextStyle(color: Colors.white),)),
              ),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.sp)
                    ),
                  ),
                  onPressed: (){
                    box.signOut();
                    loginNavKey.currentState?.popAndPushNamed('/');
                  },
                  child: Text('Sign out',
                    style: TextStyle(color: Colors.black),)),
              SizedBox(height: 5.h)
            ],
          ),
        ),
      ),
    );
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
