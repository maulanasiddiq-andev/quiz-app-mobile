import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.blue,
  onPrimary: Colors.white,
  secondary: Colors.grey,
  onSecondary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  shadow: Color.fromRGBO(26, 120, 194, 0.4)
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9CCAFF),
  onPrimary: Colors.black,
  secondary: Color(0xFFBFC8DC),
  onSecondary: Colors.black,
  error: Color(0xFFF2B8B5),
  onError: Colors.black,
  surface: Color(0xFF1E1E1E),
  onSurface: Colors.white,
);
