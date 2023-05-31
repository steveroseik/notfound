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
  final GlobalKey<SearchBarAnimation1State> searchBarKey = GlobalKey<SearchBarAnimation1State>();
  TextEditingController searchController = TextEditingController();
  late ImageProvider image;
  late BlackBox box;
  bool searching = false;
  double searchBarY = 5.h;



  @override
  void initState() {
    if (widget.image != null){
      image = widget.image!;
    }else{
      image = const AssetImage('assets/images/below.png');
    }
    tabController = TabController(length: 4, vsync: this);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: IconButton(onPressed: (){

              widget.frameKey.currentState!.toggleMenu();
            }, icon: Icon(CupertinoIcons.line_horizontal_3))),
            Flexible(child: AspectRatio(aspectRatio: 8/30, child: Image(image: AssetImage('assets/images/logo.png'), fit: BoxFit.fitWidth,))),
            Flexible(flex: 1, child: IconButton(onPressed: (){
              // print(FirebaseAuth.instance.currentUser!.displayName);
              // print(FirebaseAuth.instance.currentUser!.phoneNumber);
              // print(FirebaseAuth.instance.currentUser!.photoURL);
              // print(FirebaseAuth.instance.currentUser!.emailVerified);
              if (FirebaseAuth.instance.currentUser != null){
                box.signOut();
              }
              if (box.isGuest) box.setGuest(false);

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

  _openSearchDelegate(){
    showSearch(context: context, delegate: MySearchDelegate(searchController.text));
  }
}