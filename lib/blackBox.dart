import 'package:flutter/material.dart';

import 'objects.dart';


class BlackBox extends InheritedWidget{
  BlackBox({
    Key? key,
    required Widget child}) : super (key: key, child: child);

  static of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<BlackBox>()!.child;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

// ======================= END OF BLACK BOX ================================
// ======================== BEGIN OF CACHE =================================


class Cart{
  late List<OrderItem> items;

}