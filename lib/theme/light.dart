import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    primaryColor: Color(0xFF044b7f),
    primaryColorDark: Color(0xFF002452),
    primaryColorLight: Color(0xFF4876af),
    accentColor: Color(0xFF90caf9),
    colorScheme: ColorScheme.light().copyWith(
        primary: Color(0xFF044b7f),
        primaryVariant: Color(0xFF002452),
        onPrimary: Colors.white,
        secondary: Color(0xFF90caf9),
        secondaryVariant: Color(0xFF5d99c6),
        onSecondary: Colors.black));
