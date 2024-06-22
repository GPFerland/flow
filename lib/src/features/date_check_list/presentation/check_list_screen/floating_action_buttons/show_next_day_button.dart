import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowNextDayButton extends ConsumerWidget {
  const ShowNextDayButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      onPressed: () {},
      heroTag: "showNextDay",
      child: const Icon(
        Icons.navigate_next_rounded,
        size: 28,
      ),
    );
  }
}