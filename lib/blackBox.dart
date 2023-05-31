import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'objects.dart';


class BlackNotifier extends InheritedNotifier<BlackBox>{

  const BlackNotifier({
    Key? key,
    required BlackBox blackBox,
    required Widget child}) : super (key: key, notifier: blackBox, child: child);

  static of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<BlackNotifier>()!.notifier;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

// ======================= END OF BLACK NOTIFIER ================================
// ======================== BEGIN OF CACHE =================================


class BlackBox extends ChangeNotifier{
  bool _guest = false;
  bool _completeUser = false;

  get isGuest => _guest;
  get validUser => _completeUser;

  void completeUser(){
    _completeUser = true;
    notifyListeners();
  }

  void setGuest(bool b){
    _guest = b;
    notifyListeners();
  }

  void signOut() async{
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance.signOut();
    _completeUser = false;
    prefs.setBool('completeUser', false);

    notifyListeners();
  }
}

class Cart{
  late List<OrderItem> items;
}

