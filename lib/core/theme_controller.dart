import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode;

  ThemeController({ThemeMode initialMode = ThemeMode.light})
      : _mode = initialMode;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void setDark(bool value) {
    final newMode = value ? ThemeMode.dark : ThemeMode.light;
    if (newMode == _mode) return;
    _mode = newMode;
    notifyListeners();
  }
}