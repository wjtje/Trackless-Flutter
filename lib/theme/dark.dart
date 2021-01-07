import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    // Set the correct theme
    brightness: Brightness.dark,
    // Set the correct colors
    primaryColor: Color(0xFF044b7f),
    primaryColorDark: Color(0xFF002452),
    primaryColorLight: Color(0xFF4876af),
    accentColor: Color(0xFF90caf9),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
      switch (states) {
        default:
          return Color(0xFF90caf9);
      }
    }))),
    // Set the colorScheme for the material components
    colorScheme: ColorScheme.dark().copyWith(
        primary: Color(0xFF044b7f),
        primaryVariant: Color(0xFF002452),
        onPrimary: Colors.white,
        secondary: Color(0xFF90caf9),
        secondaryVariant: Color(0xFF5d99c6),
        onSecondary: Colors.black));
