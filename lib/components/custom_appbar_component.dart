import 'package:flutter/material.dart';

AppBar customAppbarComponent(
  String title,
  {
    List<Widget>? actions,
    bool automaticallyImplyLeading = true
  }
) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white
      ),
    ),
    actions: actions,
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}