import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/searchbar1.dart';
import 'package:notfound/newPage.dart';
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
  Offset screenOffs = const Offset(0.0, 0.0);
  Offset screenDrag = const Offset(0.0, 0.0);
  bool sideMenuOpened = false;
  HeroController heroController = HeroController();
  final image = const AssetImage('assets/images/below.png');

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

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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
                  onGenerateInitialRoutes: (navState, initialRoute) {
                    return [MaterialPageRoute(builder: (_) => mainPage(image: image, frameKey: widget.key))];
                  },
                  onGenerateRoute: RouteGenerator.gen,
                  observers: [heroController],
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
    final theme = Theme.of(context);
    final tileColor = theme.secondaryHeaderColor;
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
                CircleAvatar(
                  backgroundColor: tileColor,
                  radius: 22.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Hello, John Doe",
                  style: TextStyle(color: tileColor),
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
              toggleMenu();
              navKey.currentState?.pushNamed('/shop', arguments: widget.key as GlobalKey<MainFrameState>);
            },
            leading: Icon(Icons.shopping_bag, size: 20.0, color: tileColor),
            title: const Text("Shop", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.shopping_cart,
                size: 20.0, color: tileColor),
            title: const Text("Cart", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
             Icon(CupertinoIcons.heart_fill, size: 20.0, color: tileColor),
            title: const Text("Favorites", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              _changeThemeMode();
              toggleMenu();
            },
            leading: Icon(CupertinoIcons.moon_fill,
                size: 20.0, color: tileColor),
            title: Text(provider.darkTheme ? "Light Mode" : "Dark Mode", style: TextStyle(fontWeight: FontWeight.w600)),
            textColor: tileColor,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}



