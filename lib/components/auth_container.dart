import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final String title;

  const AuthContainer({
    super.key,
    required this.child,
    required this.title  
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                title,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 45
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Everyday Quiz',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60)
                  )
                ),
                child: child,
              )
            )
          ],
        ),
      ),
    );
  }
}