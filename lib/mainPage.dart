import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/bottomsPage.dart';
import 'package:notfound/topsPage.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'configurations.dart';
import 'mainFrame.dart';

class mainPage extends StatefulWidget {
  final ImageProvider? image;
  final frameKey;
  const mainPage({Key? key, this.image, required this.frameKey}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> with TickerProviderStateMixin{
  late TabController tabController;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late ImageProvider image;
  late BlackBox box;
  @override
  void initState() {
    if (widget.image != null){
      image = widget.image!;
    }else{
      image = const AssetImage('assets/images/below.png');
    }
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        tabController.animateTo(0);
        print('setted');
      });
    });

    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  fixTabIssue() async{
    await isBuildFinished(loaded);
    print('ran');
    Future.delayed(const Duration(milliseconds: 10)).then((value) {

    });
  }

  @override
  Widget build(BuildContext context) {
    loaded.value = true;
    box = BlackNotifier.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: IconButton(onPressed: (){

              widget.frameKey.currentState!.toggleMenu();
            }, icon: Icon(CupertinoIcons.line_horizontal_3))),
            Flexible(flex: 2, child: Image(image: AssetImage('assets/images/logo.png'))),
            Flexible(flex: 1, child: IconButton(onPressed: (){
              // print(FirebaseAuth.instance.currentUser!.uid);
              if (FirebaseAuth.instance.currentUser != null){
                FirebaseAuth.instance.signOut();
              }else{
                if (box.isGuest) box.setGuest(false);
              }

            }, icon: Stack(
              children: [
                Positioned(
                    left: 0,
                    child: Icon(Icons.shopping_cart, size: 7.w,)),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(// This is your Badge
                    padding: EdgeInsets.all(1.w),
                    constraints: BoxConstraints(maxHeight: 5.w, maxWidth: 5.w),
                    decoration: BoxDecoration( // This controls the shadow
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            color: Colors.black.withAlpha(50))
                      ],
                      borderRadius: BorderRadius.circular(15.w),
                      color: Colors.grey.shade600,  // This would be color of the Badge
                    ),             // This is your Badge
                    child: Center(
                      // Here you can put whatever content you want inside your Badge
                      child: Text('9+', style: TextStyle(color: Colors.white, fontSize: 5.sp)),
                    ),
                  ),
                ),
              ],
            )))
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
            children: [
              GestureDetector(
                onTap: (){
                },
                child: Center(
                  child: Hero(
                      tag: 'unique130',
                      child: Image.asset('assets/images/photos/photo1.jpg')),
                ),
              ),
              TopsPage(),
              BottomsPage(),
            ],
          ),
          Positioned(
            top: 3.h,
            right: 10.w,
            left: 10.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                color: Colors.blue.shade800,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              child: TabBar(
                  indicatorColor: Colors.green,
                  indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  indicatorWeight: 5.sp,
                  indicator:  BoxDecoration(
                      image: DecorationImage(
                          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcATop),
                          image: image )
                  ),
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  padding: EdgeInsets.all(5.w),
                  isScrollable: true,
                  controller: tabController,
                  tabs:[
                    FittedBox(child: Text('LATEST', style: TextStyle(fontSize: 8.sp),)),
                    FittedBox(child: Text('TOPS', style: TextStyle(fontSize: 8.sp))),
                    FittedBox(child: Text('BOTTOMS', style: TextStyle(fontSize: 8.sp))),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}