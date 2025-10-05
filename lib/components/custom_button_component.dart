import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  final Function onTap;
  final String text;
  final bool isLoading;
  final bool isError;
  const CustomButtonComponent({
    super.key, 
    required this.onTap, 
    required this.text,
    this.isLoading = false,
    this.isError = false
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onTap(),
      splashColor: Colors.white.withAlpha(100),
      child: Ink(
        height: 50,
        decoration: BoxDecoration(
          color: isError ? colors.error : colors.primary,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: isLoading
          ? SizedBox(
              height: 45,
              width: 45,
              child: Center(
                child: CircularProgressIndicator(color: colors.onPrimary)
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 16,
              ),
          ),
        )
      ),
    );
  }
}