import 'package:flow/providers/theme/show_completed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HideCompletedItemsButton extends ConsumerWidget {
  const HideCompletedItemsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showCompleted = ref.watch(showCompletedProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            ref.read(showCompletedProvider.notifier).updateShowCompleted(
                  !showCompleted,
                  context,
                );
          },
          child: Text(showCompleted ? 'Hide Completed' : 'Show Completed'),
        ),
      ),
    );
  }
}
