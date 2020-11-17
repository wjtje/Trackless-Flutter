import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF49cbf3),
    primaryColorLight: Color(0xFF86FEFF),
    accentColor: Color(0xFF564ae4),
    colorScheme: ColorScheme.light().copyWith(
      primary: Color(0xFF49cbf3),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFF564ae4),
      onSecondary: Color(0xFFFFFFFF),
    ));
