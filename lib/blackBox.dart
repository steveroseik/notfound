import 'package:flutter/material.dart';

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

  get isGuest => _guest;
  void setGuest(bool b){
    _guest = b;
    notifyListeners();
  }
}

class Cart{
  late List<OrderItem> items;
}

