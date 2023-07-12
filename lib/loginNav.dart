import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';

import 'main.dart';


class LoginNav extends StatefulWidget {
  final BlackBox box;
  const LoginNav({Key? key, required this.box}) : super(key: key);

  @override
  State<LoginNav> createState() => _LoginNavState();
}

class _LoginNavState extends State<LoginNav> {
  MyAppState? myAppState;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if the LoginNav widget is already disposed
    myAppState = context.findAncestorStateOfType<MyAppState>();
    if (myAppState != null && myAppState!.isLoginDisposed.value) {
      myAppState!.isLoginDisposed.value = false;
    }
  }

 @override
 void dispose(){
   if (myAppState != null) {
     myAppState!.isLoginDisposed.value = true;
   }
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {

    return Navigator(
      key: loginNavKey,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.gen1,
    );
  }
}
