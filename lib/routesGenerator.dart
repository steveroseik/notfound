import 'package:flutter/material.dart';
import 'package:notfound/CardPage.dart';
import 'package:notfound/completeUserInfo.dart';
import 'package:notfound/signUpPage.dart';
import 'package:notfound/addressPage.dart';
import 'package:notfound/editAddressPage.dart';
import 'package:notfound/editCardsPage.dart';
import 'package:notfound/latestPage.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/mainFrame.dart';
import 'package:notfound/mainPage.dart';
import 'package:notfound/profilePage.dart';
import 'package:notfound/searchPage.dart';
import 'package:notfound/shopPage.dart';
import 'package:notfound/widgets.dart';
import 'ProductPage.dart';


final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> loginNavKey = GlobalKey<NavigatorState>();


class RouteGenerator{

  static Route<dynamic> gen(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //       builder: (context) => mainPage());
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
      case '/editAddress': return MaterialPageRoute(builder: (context) => EditAddressPage());
      case '/search': return MaterialPageRoute(builder: (context) => SearchPage());
      case '/shop': {
        if (args is GlobalKey<MainFrameState>){
          return MaterialPageRoute(builder: (context) => ShopPage(menuKey: args));
        }
        return _errorRoute();
      }
      case '/addressPage': {
        if (args is AddressInfo){
          return MaterialPageRoute(builder: (context) => AddressPage(addressInfo: args));
        }else{
          return MaterialPageRoute(builder: (context) => AddressPage());
        }
      }

      default: return _errorRoute();
    }

  }
  static Route<dynamic> gen1(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (context) => LoginPage());
    case '/signup':
      return MaterialPageRoute(builder: (context) => SignUpPage());
    case '/incomplete':
      return MaterialPageRoute(builder: (context) => CompleteUserInfo());

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



