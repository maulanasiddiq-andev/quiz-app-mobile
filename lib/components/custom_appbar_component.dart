import 'package:flutter/material.dart';

AppBar customAppbarComponent(
  String title,
  {
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
    Color backgroundColor = Colors.blue,
    Color foregroundColor = Colors.white
  }
) {

  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: foregroundColor
      ),
    ),
    actions: actions,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}