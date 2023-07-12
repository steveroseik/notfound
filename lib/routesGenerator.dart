import 'package:flutter/material.dart';
import 'package:notfound/CardPage.dart';
import 'package:notfound/cashPaymentSuccess.dart';
import 'package:notfound/changePhoneNumber.dart';
import 'package:notfound/checkout.dart';
import 'package:notfound/completeUserInfo.dart';
import 'package:notfound/editUserInfo.dart';
import 'package:notfound/forgotPassword.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/pastOrders.dart';
import 'package:notfound/paymentGateway.dart';
import 'package:notfound/paymentSuccess.dart';
import 'package:notfound/preCheckOutPage.dart';
import 'package:notfound/productsViewPage.dart';
import 'package:notfound/shoppingCart.dart';
import 'package:notfound/signUpPage.dart';
import 'package:notfound/addressPage.dart';
import 'package:notfound/editAddressPage.dart';
import 'package:notfound/editCardsPage.dart';
import 'package:notfound/loginPage.dart';
import 'package:notfound/mainFrame.dart';
import 'package:notfound/profilePage.dart';
import 'package:notfound/searchPage.dart';
import 'package:notfound/shopPage.dart';
import 'package:notfound/productPage.dart';
import 'package:notfound/verifyEmailPage.dart';
import 'package:notfound/widgets.dart';

import 'mainPage.dart';


final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> loginNavKey = GlobalKey<NavigatorState>();


class RouteGenerator{

  static Route<dynamic> gen(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => mainPage());
      case '/productPage':
        if (args is List) {
          if (args[0] is Product) {
            return MaterialPageRoute(
              builder: (context) => ProductPage(product: args[0], tag: args[1]));
          }else if (args[0] is int){
            return MaterialPageRoute(
                builder: (context) => ProductPage(productId: args[0], tag: args[1],));
          }
        }
        return _errorRoute();
      case '/profile': return MaterialPageRoute(builder: (context) => ProfilePage());
      case '/editCards': return MaterialPageRoute(builder: (context) => EditCardsPage());
      case '/cardPage':
        if (args is CreditCard){
          return MaterialPageRoute(builder: (context) => CardPage(card: args));
        }else if (args == null){
          return MaterialPageRoute(builder: (context) => const CardPage());
        }
        return _errorRoute();
      case '/editAddress':
        if (args is bool) return MaterialPageRoute(builder: (context) => EditAddressPage(showCart: args));
        if (args == null) return MaterialPageRoute(builder: (context) => const EditAddressPage());
        return _errorRoute();

      case '/search': return MaterialPageRoute(builder: (context) => const SearchPage());
      case '/shop': {
        if (args is GlobalKey<MainFrameState>){
          return MaterialPageRoute(builder: (context) => ShopPage(menuKey: args));
        }
        return _errorRoute();
      }
      case '/addressPage': {
        if (args is AddressItem){
          return MaterialPageRoute(builder: (context) => AddressPage(item: args));
        }else{
          return MaterialPageRoute(builder: (context) => AddressPage());
        }
      }

      case '/preCheckOut': return MaterialPageRoute(builder: (context) => PreCheckOutPage());

      case '/pay':
        if (args is String){
          return MaterialPageRoute(builder: (context) => PaymentPage(session: args));
        }
        return _errorRoute();

      case '/payOnline':
        if (args is List) return MaterialPageRoute(builder: (context) => CheckOutOnline(data: args[0], items: args[1],));
        return _errorRoute();

      case '/cart': return MaterialPageRoute(builder: (context) => ShoppingCartPage());

      case '/paymentSuccess':
        if (args is Receipt) return MaterialPageRoute(builder: (context) => PaymentSuccessPage(order: args));
        return _errorRoute();

      case '/cashSuccess':
        if (args is Receipt) return MaterialPageRoute(builder: (context) => CashPaymentSuccessPage(order: args));
        return _errorRoute();


      case '/pastOrders': return MaterialPageRoute(builder: (context) => PastOrdersPage());

      case '/editInfo': return MaterialPageRoute(builder: (context) => EditUserInfo());

      case '/phonePage': return MaterialPageRoute(builder: (context) => PhoneNumberPage());

      case '/productsView':
        if (args is Collection ) return MaterialPageRoute(builder: (context) => ProductsViewPage(collection: args));
        if (args is List<ProductElement>) return MaterialPageRoute(builder: (context) => ProductsViewPage(productList: args));
        if (args is Category ) return MaterialPageRoute(builder: (context) => ProductsViewPage(category: args));
        if (args is bool ) return MaterialPageRoute(builder: (context) => ProductsViewPage(fav: args));
        return _errorRoute();

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
    case '/verifyEmail':
      return MaterialPageRoute(builder: (context) => VerifyEmailPage());
    case '/forgot':
        return MaterialPageRoute(builder: (context) => ForgotPassPage());

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



