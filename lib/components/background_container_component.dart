import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackgroundContainerComponent extends StatelessWidget {
  final Widget child;
  
  const BackgroundContainerComponent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double width = kIsWeb ? 400 : double.infinity;
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          color: colors.primary,
          width: width,
          child: child
        )
      ),
    );
  }
}