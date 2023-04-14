import 'package:flutter/material.dart';
import 'package:notfound/CardPage.dart';
import 'package:notfound/addressPage.dart';
import 'package:notfound/editCardsPage.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/profilePage.dart';
import 'package:notfound/widgets.dart';
import 'ProductPage.dart';


final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();


class RouteGenerator{

  static Route<dynamic> gen(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => mainPage());
      case '/productPage':
        if (args is List) {
          return MaterialPageRoute(
              builder: (context) => ProductPage(index: args[0], tag: args[1],));
        }
        return _errorRoute();
      case '/profile': return MaterialPageRoute(builder: (context) => ProfilePage());
      case '/editCards': return MaterialPageRoute(builder: (context) => EditCardsPage());
      case '/cardPage':
        if (args is CreditCard){
          return MaterialPageRoute(builder: (context) => CardPage(card: args));
        }else if (args == null){
          return MaterialPageRoute(builder: (context) => CardPage());
        }
        return _errorRoute();
      case '/addressPage': return MaterialPageRoute(builder: (context) => AddressPage());

      default: return _errorRoute();
    }

  }

    static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold( // AppBar
        body: Center(
          child: Text('ERROR'),
        ), // Center
      ); // Scaffold
    }); // Material PageRoute
  }
}



