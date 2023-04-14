import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/darkThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'configurations.dart';
import 'homePage.dart';

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
  bool loaded = false;

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
              return MaterialApp(
                  theme: Styles.themeData(false, context),
                  darkTheme: Styles.themeData(true, context),
                  themeMode: themeProvider.darkTheme ? ThemeMode.dark : ThemeMode.light,
                  home: Builder(
                    builder: (BuildContext context){
                      return MainFrame();
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