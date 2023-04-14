import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/topsPage.dart';
import 'package:notfound/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'ProductPage.dart';
import 'base.dart';
import 'darkThemeProvider.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> with TickerProviderStateMixin{

  late DarkThemeProvider provider;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  Offset screenOffs = const Offset(0.0, 0.0);
  Offset screenDrag = const Offset(0.0, 0.0);
  bool sideMenuOpened = false;
  HeroController heroController = HeroController();

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DarkThemeProvider>(context);
    final theme = Theme.of(context);
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
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: IconButton(onPressed: (){
                  toggleMenu();
                }, icon: Icon(CupertinoIcons.line_horizontal_3))),
                Flexible(flex: 2, child: Image(image: AssetImage('assets/images/logo.png'))),
                Flexible(flex: 1, child: IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart)))
              ],
            ),
          ),
          body: IgnorePointer(
            ignoring: sideMenuOpened,
            child: Navigator(
              key: navKey,
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.gen,
              observers: [heroController],
            ),
          ),// This trailing comma makes auto-formatting nicer for build methods.
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
            leading: const Icon(Icons.verified_user,
                size: 20.0, color: Colors.white),
            title: const Text("Profile"),
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
            onTap: () {},
            leading:
            const Icon(Icons.settings, size: 20.0, color: Colors.white),
            title: const Text("Settings"),
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



