import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/darkThemeProvider.dart';
import 'package:notfound/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';
import 'mainFrame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeProvider = DarkThemeProvider();
  final GlobalKey<MainFrameState> mainState = GlobalKey<MainFrameState>();
  bool loaded = false;

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
                            BlackBox box = BlackNotifier.of(context);
                            return StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
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
                                  child: snapshot.hasData || box.isGuest ? MainFrame(key: mainState)
                                      : snapshot.connectionState == ConnectionState.waiting ?
                                        const Center(key: Key('loadingCircle'), child: CircularProgressIndicator(color: Colors.green, strokeWidth: 5)) :
                                        const LoginPage(key: Key('LoginPage'))
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
}
