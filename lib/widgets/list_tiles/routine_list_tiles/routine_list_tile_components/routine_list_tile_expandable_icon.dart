import 'package:flutter/material.dart';

class AnimatedExpandIcon extends StatelessWidget {
  const AnimatedExpandIcon({
    super.key,
    required this.isExpanded,
  });

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 0.5).animate(animation),
          child: child,
        );
      },
      child: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        key: ValueKey<bool>(isExpanded),
      ),
    );
  }
}
