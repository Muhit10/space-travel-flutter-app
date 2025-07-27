import 'package:flutter/material.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? AppTheme.darkTheme : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}