import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.light,
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.dark,
  );
}