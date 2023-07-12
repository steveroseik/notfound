import 'dart:async';
import 'dart:math';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/darkThemeProvider.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/notif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';
import 'loginNav.dart';
import 'mainFrame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService().setupInteractedMessage();
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('App received a notification when it was killed');
  }
  final token = await FirebaseMessaging.instance.getToken();
  print('Token: $token');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  DarkThemeProvider themeProvider = DarkThemeProvider();
  final GlobalKey<MainFrameState> mainState = GlobalKey<MainFrameState>();
  bool loaded = false;
  ValueNotifier<bool> isLoginDisposed = ValueNotifier<bool>(true);
  ValueNotifier<Widget> animatedWidget  =ValueNotifier<Widget>(Container());
  ValueNotifier<Widget> loadingWidget  =ValueNotifier<Widget>(Container(key: const Key('HaltLoadingKey')));

  // Widget animatedWidget = Container();
  int connection = 0;
  final BlackBox _box = BlackBox();

  @override
  void initState() {
    _getThemeAsync();
    super.initState();
  }

  void _getThemeAsync() async {
    await getCurrentAppTheme();
    setState(() {
      loaded = true;
    });
  }

  getCurrentAppTheme() async {
    themeProvider.darkTheme = await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {

    return !loaded ? const CircularProgressIndicator() : ChangeNotifierProvider<DarkThemeProvider>(
      create: (_){
        return themeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? widget){
          return Sizer(
            builder:(context, orientation, deviceType){
              return BlackNotifier(
                blackBox: _box,
                child: Builder(
                  builder: (context) {
                    return MaterialApp(
                        theme: Styles.themeData(false, context),
                        darkTheme: Styles.themeData(true, context),
                        themeMode: themeProvider.darkTheme ? ThemeMode.dark : ThemeMode.light,
                        home: Builder(
                          builder: (BuildContext context){
                            return StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                BlackBox box = BlackNotifier.of(context);
                                refreshWidgets(snapshot, box);
                                return Stack(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: animatedWidget,
                                      builder: (context, value, widget){
                                        return AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 500),
                                            switchInCurve: Curves.easeOut,
                                            switchOutCurve: Curves.easeOut,
                                            transitionBuilder: (Widget child, Animation<double> animation) {
                                              final bool isNewWidget = animation.status == AnimationStatus.reverse;
                                              final slideTransition = SlideTransition(
                                                  position: Tween<Offset>(begin: isNewWidget ? const Offset(-0.5,0) : const Offset(0.5,0), end: const Offset(0,0)).animate(animation),
                                                  child: child);
                                              return ScaleTransition(
                                                scale: animation,
                                                child: slideTransition,
                                              );
                                            },
                                            child: value
                                        );
                                      },
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: loadingWidget,
                                      builder: (context, value, widget){
                                        return AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 100),
                                            transitionBuilder: (widget, animation){
                                              return ScaleTransition(scale: animation, child: widget);
                                            },
                                            child: value
                                        );
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        )
                    );
                  }
                ),
              );
            }
          );
        },
      ),
    );
  }
  refreshWidgets(AsyncSnapshot<User?> snapshot, BlackBox box) async{
    if (snapshot.connectionState == ConnectionState.waiting){
      if (!loadingWidget.value.key.toString().contains('HaltLoadingKey')){
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          if (snapshot.connectionState == ConnectionState.waiting){
            loadingWidget.value = const Scaffold(
              body:  Center(key: Key('loadingC'),
                  child: CircularProgressIndicator(
                      color: Colors.green, strokeWidth: 5)),
            );
          }
        });
      }
    }else{
      if (!loadingWidget.value.key.toString().contains('HaltLoadingKey')){
        loadingWidget.value = Container(key: const Key('HaltLoadingKey'));
      }
    }

    if (box.validUser || box.isGuest){
      if(animatedWidget.value.key != mainState){
        animatedWidget.value = MainFrame(key: mainState);
      }

    }else{
      if (!animatedWidget.value.key.toString().contains('login')){
        animatedWidget.value = LoginNav(key: const Key('login'), box: box);
      }
    }
  }

}
