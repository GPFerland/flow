import 'package:flutter/material.dart';

class DividerOnSecondaryContainer extends StatelessWidget {
  const DividerOnSecondaryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color:
          Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.5),
    );
  }
}
