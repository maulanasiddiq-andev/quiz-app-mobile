import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  final Function onTap;
  final String text;
  final bool isLoading;
  const CustomButtonComponent({
    super.key, 
    required this.onTap, 
    required this.text,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      splashColor: Colors.white.withAlpha(100),
      child: Ink(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: isLoading
          ? SizedBox(
              height: 45,
              width: 45,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white)
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
          ),
        )
      ),
    );
  }
}