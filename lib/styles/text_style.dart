import 'package:flutter/material.dart';
import 'package:quiz_app/constants/layout_constant.dart';

class CustomTextStyle {
  static TextStyle smallTextStyle = TextStyle(
    fontSize: LayoutConstant.smallFontSize
  );

  static TextStyle defaultTextStyle = TextStyle(
    fontSize: LayoutConstant.mediumFontSize
  );

  static TextStyle defaultBoldTextStyle = TextStyle(
    fontSize: LayoutConstant.mediumFontSize,
    fontWeight: FontWeight.bold
  );

  static TextStyle headerStyle = TextStyle(
    fontSize: LayoutConstant.largeFontSize,
  );
}