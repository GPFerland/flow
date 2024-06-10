import 'package:flutter/material.dart';

class DefaultDrawerDivider extends StatelessWidget {
  const DefaultDrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 32,
      ),
      child: Container(
        height: 2,
        color:
            Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.2),
      ),
    );
  }
}
