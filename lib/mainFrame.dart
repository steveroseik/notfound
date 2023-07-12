import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/searchbar1.dart';
import 'package:notfound/newPage.dart';
import 'package:notfound/tabBarIndicator.dart';
import 'package:notfound/widgets.dart';
import 'package:provider/provider.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'ProductPage.dart';
import 'base.dart';
import 'blackBox.dart';
import 'darkThemeProvider.dart';

class MainFrame extends StatefulWidget {
  final bool? firstLogin;
  const MainFrame({super.key, this.firstLogin});

  @override
  State<MainFrame> createState() => MainFrameState();
}

class MainFrameState extends State<MainFrame> with TickerProviderStateMixin{

  late DarkThemeProvider provider;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  Offset screenOffs = const Offset(0.0, 0.0);
  Offset screenDrag = const Offset(0.0, 0.0);
  bool sideMenuOpened = false;
  HeroController heroController = HeroController();
  ValueNotifier<bool> b_init = ValueNotifier(false);
  late BlackBox box;
  bool loading = true;
  bool currencyChanging = false;

  late TabController currencyControl;

  void _changeThemeMode() {
    setState(() {
      provider.darkTheme = !provider.darkTheme;
    });
  }

  toggleMenu() {
    final state = _sideMenuKey.currentState!;
    sideMenuOpened = !state.isOpened;
    if (state.isOpened) {
      state.closeSideMenu();
    } else {
      state.openSideMenu();
    }
    setState(() {});
  }

  @override
  void initState() {
    currencyControl = TabController(length: 3, vsync: this)..addListener(() {
      box.updateCurrentCurrency(currencyControl.index);
    });
    initializeCache();
    super.initState();
  }

  initializeCache() async{
    if (!b_init.value) await isBuildFinished(b_init);
    final prefs = await SharedPreferences.getInstance();
    await box.initCache(prefs);
    switch(box.currentCurrency){
      case 'USD': currencyControl.animateTo(1);
      break;
      case 'EUR': currencyControl.animateTo(2);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DarkThemeProvider>(context);
    final theme = Theme.of(context);
    box = BlackNotifier.of(context);
    box.frameKey ??= widget.key;
    if (!b_init.value) b_init.value = true;
    return (box.isGuest || box.validUser) ? SideMenu(
      key: _sideMenuKey,
      background: theme.primaryColor,
      menu: buildMenu(),
      type: SideMenuType.slideNRotate,
      child: GestureDetector(
        onTap: (){
          if (_sideMenuKey.currentState!.isOpened){
            toggleMenu();
          }
        },
        onPanStart: (details){
          screenDrag  = details.globalPosition;
        },
        onPanUpdate: (details){
          screenOffs = details.globalPosition;
        },
        onPanEnd: onPanEnd,
        child: Scaffold(
          body: IgnorePointer(
            ignoring: sideMenuOpened,
            child: Stack(
              children: [
                Navigator(
                  key: navKey,
                  initialRoute: '/',
                  onGenerateRoute: RouteGenerator.gen,
                  observers: [heroController],
                ),
                loading ? loadingWidget(loading, opacity: 1) : Container()
              ],
            ),
          ),
        ),
      ),
    ) : Container();
  }
  void onPanEnd(details){
    // print("start : ${screenDrag.dx} -> end: ${screenOffs.dx}");
    if (screenDrag.dx > 0.0 && screenDrag.dx < context.size!.width / 5){
      if ((screenOffs.dx - screenDrag.dx) < context.size!.width / 2){
        final absHeight = (screenOffs.dy - screenDrag.dy).abs();
        final absWidth =  (screenOffs.dx - screenDrag.dx).abs();
        if (absHeight < absWidth){
          if (!_sideMenuKey.currentState!.isOpened){
            toggleMenu();
          }
        }
      }
    }else if(screenDrag.dx > context.size!.width / 3){
      if ((screenOffs.dx - screenDrag.dx) < 0){
        if (_sideMenuKey.currentState!.isOpened){
          toggleMenu();
        }
      }
    }
  }



  Widget buildMenu() {
    final theme = Theme.of(context);
    final tileColor = Colors.black;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  box.isGuest ?  "Hello, Guest" :
                      '${box.userPod()!.firstName.capitalize()} ${box.userPod()!.lastName.capitalize()}',
                  style: TextStyle(color: tileColor, fontWeight: FontWeight.w600,),
                  presetFontSizes: [15.sp, 14.sp, 13.sp, 12.sp, 11.sp, 10.sp],
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              navKey.currentState?.pushNamed('/profile');
            },
            leading: Icon(CupertinoIcons.profile_circled,
                size: 20.0, color: tileColor),
            title: const Text("Account", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              if (navKey.currentState!.canPop()){
                navKey.currentState?.popUntil((route) => route.isFirst);
                toggleMenu();
              }else{
                toggleMenu();
              }
            },
            leading:
            Icon(CupertinoIcons.house_alt_fill, size: 20.0, color: tileColor),
            title: const Text("Home", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              navKey.currentState?.pushNamed('/shop', arguments: widget.key as GlobalKey<MainFrameState>);
            },
            leading: Icon(Icons.shopping_bag, size: 20.0, color: tileColor),
            title: const Text("Shop", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              navKey.currentState?.pushNamed('/cart');
            },
            leading: Icon(Icons.shopping_cart,
                size: 20.0, color: tileColor),
            title: const Text("Cart", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              final prods = box.likedProductsItems();
              if (prods.isEmpty) {
                showErrorBar(context, 'No products found!');
              }else{
                navKey.currentState?.pushNamed('/productsView', arguments: true);
              }
              toggleMenu();
            },
            leading:
             Icon(CupertinoIcons.heart_fill, size: 20.0, color: tileColor),
            title: const Text("Wishlist", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          TabBar(
              indicatorColor: Colors.blue.shade900,
              indicatorWeight: 0.5.sp,
              labelColor: Colors.white,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5.sp),
                color: Colors.black,
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
              unselectedLabelColor: Colors.grey,
              padding: EdgeInsets.all(5.w),
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(1.sp),
              controller: currencyControl,
              tabs:const [
                FittedBox(child: Text('EGP', style: TextStyle(fontWeight: FontWeight.w600),)),
                FittedBox(child: Text('USD', style: TextStyle(fontWeight: FontWeight.w600))),
                FittedBox(child: Text('EUR', style: TextStyle(fontWeight: FontWeight.w600))),
              ]),
        ],
      ),
    );
  }
}



