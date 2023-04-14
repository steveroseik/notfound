import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notfound/bottomsPage.dart';
import 'package:notfound/topsPage.dart';
import 'package:sizer/sizer.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> with TickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                indicator:  const BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcATop),
                        image: AssetImage('assets/images/below.png'),
                        filterQuality: FilterQuality.high,
                    )),
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
    );
  }
}
