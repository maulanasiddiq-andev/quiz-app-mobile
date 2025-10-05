import 'package:flutter/material.dart';

class QuizNavigationButtonComponent extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String? text;
  final TextDirection? textDirection;
  const QuizNavigationButtonComponent({
    super.key,
    required this.onTap,
    required this.icon,
    this.text,
    this.textDirection = TextDirection.ltr
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onTap(),
      splashColor: Colors.white.withAlpha(100),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: colors.primary,
        child: Row(
          textDirection: textDirection,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: text == null ? 0 : 10,
          children: [
            Icon(icon, color: colors.onPrimary),
            text == null
            ? SizedBox()
            : Text(
                text!, 
                style: TextStyle(
                  fontSize: 16,
                  color: colors.onPrimary
                )
              ),
          ],
        ),
      ),
    );
  }
}