import 'package:flutter/material.dart';

class Database
{
  static final ThemeData _themeData = ThemeData
  (
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
  );
  static ThemeData get themeData => _themeData;
  static ColorScheme get colorScheme => _themeData.colorScheme;
}