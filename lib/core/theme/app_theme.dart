import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff121212),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff4FC3F7),
      secondary: Color(0xff90CAF9),
    ),
    cardColor: const Color(0xff1E1E1E),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff252525),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
