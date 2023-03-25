import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/darkThemeProvider.dart';
import 'package:notfound/tabBarIndicator.dart';
import 'package:notfound/topsPage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'base.dart';

import 'configurations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }


  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
    await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkThemeProvider>(
      create: (_){
        return themeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? widget){
          return Sizer(
            builder:(context, orientation, deviceType){
              return MaterialApp(
                  theme: Styles.themeData(false, context),
                  darkTheme: Styles.themeData(true, context),
                  themeMode: themeProvider.darkTheme ? ThemeMode.dark : ThemeMode.light,
                  home: Builder(
                    builder: (BuildContext context){
                      return MyHomePage(title: 'NOTFOUND');
                    },
                  )
              );
            }
          );
        },
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  late DarkThemeProvider provider;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  Offset screenOffs = Offset(0.0, 0.0);
  Offset screenDrag = Offset(0.0, 0.0);
  bool sideMenuOpened = false;
  late TabController tabController;
  late PageController _pageController;


  void _incrementCounter() {
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
    provider = Provider.of<DarkThemeProvider>(context);
    final theme = Theme.of(context);
    return SideMenu(
      key: _sideMenuKey,
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
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: IconButton(onPressed: (){
                  toggleMenu();
                }, icon: Icon(CupertinoIcons.list_dash))),
                Flexible(flex: 2, child: Image(image: AssetImage('assets/images/logo.png'))),
                Flexible(flex: 1, child: IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart)))
              ],
            ),
          ),
          body: IgnorePointer(
            ignoring: sideMenuOpened,
            child: Stack(
              children: [
                TabBarView(
                  controller: tabController,
                  children: [
                    Container(color: Colors.red),
                    TopsPage(),
                    Container(color: Colors.blue),
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
                      indicatorPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      indicatorWeight: 5.sp,
                      indicator:  const BoxDecoration(
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcATop),
                              image: AssetImage('assets/images/below.png'),
                              fit: BoxFit.fill)),
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      padding: EdgeInsets.all(5.w),
                      isScrollable: true,
                        controller: tabController,
                        tabs:[
                          FittedBox(child: Text('LATEST')),
                          FittedBox(child: Text('TOPS')),
                          FittedBox(child: Text('BOTTOMS')),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  Widget firstTrial(ThemeData theme){
    return ContainedTabBarView(

      tabBarProperties: TabBarProperties(
        indicatorColor: theme.textSelectionTheme.selectionColor,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: theme.disabledColor,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        indicatorWeight: 2,
      ),
      tabs: [
        FittedBox(child: Text('HOME')),
        FittedBox(child: Text('NEW')),
        FittedBox(child: Text('SALE')),
        FittedBox(child: Text('BEST SELLERS')),
      ],
      views: [
        Container(color: Colors.red),
        Container(color: Colors.green),
        Container(color: Colors.blue),
        Container(color: Colors.grey)
      ],
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

  TextStyle barStyle({bool? active}){
    if (active?? false){
      return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w600,
      );
    }else{
      return TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w300,
      );
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
          onTap: () {},
          leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
          title: const Text("Home"),
          textColor: Colors.white,
          dense: true,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.verified_user,
              size: 20.0, color: Colors.white),
          title: const Text("Profile"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.monetization_on,
              size: 20.0, color: Colors.white),
          title: const Text("Wallet"),
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
          const Icon(Icons.star_border, size: 20.0, color: Colors.white),
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
      ],
    ),
  );
}
