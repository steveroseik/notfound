import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/searchbar1.dart';
import 'package:notfound/topsPage.dart';
import 'package:notfound/widgets.dart';
import 'package:provider/provider.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:sizer/sizer.dart';

import 'ProductPage.dart';
import 'base.dart';
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
  final GlobalKey<SearchBarAnimation1State> searchBarKey = GlobalKey<SearchBarAnimation1State>();
  Offset screenOffs = const Offset(0.0, 0.0);
  Offset screenDrag = const Offset(0.0, 0.0);
  bool sideMenuOpened = false;
  HeroController heroController = HeroController();
  final image = const AssetImage('assets/images/below.png');
  bool searching = false;
  double searchBarY = 10.h;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(image, context).then(_markNeedsBuild);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _markNeedsBuild([_]) {
    if(mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DarkThemeProvider>(context);
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    return SideMenu(
      key: _sideMenuKey,
      background: Colors.blue,
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
                  onGenerateInitialRoutes: (navState, initialRoute) {
                    return [MaterialPageRoute(builder: (_) => mainPage(image: image, frameKey: widget.key))];
                  },
                  onGenerateRoute: RouteGenerator.gen,
                  observers: [heroController],
                ),
                AnimatedPositioned(
                  top: searchBarY + 8.h,
                  left: 5.w,
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                    visible: searching,
                    child: SizedBox(
                      height: 4.h,
                      width: 80.w,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: 3,
                          itemBuilder: (context, index){
                            return CircleAvatar(child: CircleAvatar(backgroundColor: Colors.red,));
                          }),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: searchBarY,
                  left: 5.w,
                  duration: const Duration(milliseconds: 300),
                  child: SearchBarAnimation1(
                    key: searchBarKey,
                    textEditingController: TextEditingController(),
                    searchBoxWidth: 90.w,
                    isOriginalAnimation: false,
                    isSearchBoxOnRightSide: false,
                    durationInMilliSeconds: 500,
                    buttonBorderColour: Colors.black45,
                    trailingWidget: Icon(CupertinoIcons.search),
                    secondaryButtonWidget: Icon(CupertinoIcons.xmark),
                    buttonWidget: Icon(CupertinoIcons.search),
                    onFieldSubmitted: (String value){
                      debugPrint('onFieldSubmitted value $value');
                    },
                    onPressButton: (bool open){
                      if (!open) {
                        if (searching){
                          navKey.currentState?.pop();
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                        searchBarY = 10.h;
                      }else{
                        navKey.currentState?.pushNamed('/search')
                            .then((value) {
                          if (searching){
                            setState(() {
                              searching = !searching;
                            });
                            searchBarKey.currentState?.onTapOriginal();
                          }
                        });
                        setState(() {
                          searchBarY = 0;
                        });
                      }
                      setState(() {
                        searching = open;
                      });
                    },
                    onChanged: (){
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Hello, John Doe",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              navKey.currentState?.popUntil((route) => route.isFirst);
            },
            leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
            title: const Text("Home"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              navKey.currentState?.pushNamed('/profile');
            },
            leading: const Icon(CupertinoIcons.profile_circled,
                size: 20.0, color: Colors.white),
            title: const Text("Account"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.shopping_cart,
                size: 20.0, color: Colors.white),
            title: const Text("Cart"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
            const Icon(CupertinoIcons.heart_fill, size: 20.0, color: Colors.white),
            title: const Text("Favorites"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              _changeThemeMode();
              toggleMenu();
            },
            leading: const Icon(CupertinoIcons.moon_fill,
                size: 20.0, color: Colors.white),
            title: Text(provider.darkTheme ? "Light Mode" : "Dark Mode"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}



