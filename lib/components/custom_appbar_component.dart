import 'package:flutter/material.dart';

class CustomAppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  const CustomAppbarComponent({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: colors.onPrimary
        ),
      ),
      actions: actions,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}