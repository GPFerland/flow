import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowPreviousDayButton extends ConsumerWidget {
  const ShowPreviousDayButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      onPressed: () {},
      heroTag: "showPreviousDay",
      child: const Icon(
        Icons.navigate_before_rounded,
        size: 28,
      ),
    );
  }
}
