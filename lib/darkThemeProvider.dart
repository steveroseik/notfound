import 'package:flutter/material.dart';
import 'darkThemePrefs.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePrefs darkThemePreference = DarkThemePrefs();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
