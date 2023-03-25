import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xff3B3B3B)) : MaterialStateProperty.all<Color>(Color(0xffF1F5FB)),
            foregroundColor: isDarkTheme ? MaterialStateProperty.all<Color>(Color(0xffF1F5FB)) : MaterialStateProperty.all<Color>(Color(0xff3B3B3B))
        ),
      ),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey.shade500,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ), colorScheme: ColorScheme.fromSwatch(
        primarySwatch: isDarkTheme ? Colors.grey :  Colors.blueGrey,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light).copyWith(
        background: isDarkTheme ? Colors.black : const Color(0xffF1F5FB)),
      textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );

  }
}