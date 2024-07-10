import 'package:flutter/material.dart';

class DividerOnPrimaryContainer extends StatelessWidget {
  const DividerOnPrimaryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.15),
    );
  }
}
