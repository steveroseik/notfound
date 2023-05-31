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
  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Navigator(
          key: loginNavKey,
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.gen1,
    ));
  }
}
