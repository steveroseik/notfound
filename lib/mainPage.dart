import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/bestSellersPage.dart';
import 'package:notfound/latestPage.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/searchEngine.dart';
import 'package:notfound/searchPage.dart';
import 'package:notfound/searchbar1.dart';
import 'package:notfound/newPage.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'configurations.dart';
import 'mainFrame.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> with TickerProviderStateMixin{
  late TabController tabController;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  final GlobalKey<SearchBarAnimation1State> searchBarKey = GlobalKey<SearchBarAnimation1State>();
  TextEditingController searchController = TextEditingController();
  late ImageProvider image;
  late BlackBox box;
  bool searching = false;
  double searchBarY = 5.h;



  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        tabController.animateTo(0);
      });
    });

    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loaded.value = true;
    box = BlackNotifier.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(context: context, box: box, homePage: true),
      body: Stack(
        children: [
          Column(
            children: [
              TabBar(
                  indicatorColor: Colors.blue.shade900,
                  indicatorWeight: 0.5.sp,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.blue.shade900,
                  labelPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                  unselectedLabelColor: Colors.grey,
                  padding: EdgeInsets.all(5.w),
                  isScrollable: true,
                  splashBorderRadius: BorderRadius.circular(1.sp),
                  controller: tabController,
                  tabs:const [
                    FittedBox(child: Text('LATEST', style: TextStyle(fontWeight: FontWeight.w600),)),
                    FittedBox(child: Text('NEW', style: TextStyle(fontWeight: FontWeight.w600))),
                    FittedBox(child: Text('BEST SELLERS', style: TextStyle(fontWeight: FontWeight.w600))),
                    FittedBox(child: Text('SALE', style: TextStyle(fontWeight: FontWeight.w600))),
                  ]),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    LatestPage(),
                    newPage(),
                    BestSellersPage(),
                    BestSellersPage(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}