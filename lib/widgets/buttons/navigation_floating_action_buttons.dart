import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationFloatingActionButtons extends ConsumerWidget {
  const NavigationFloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              ref.read(selectedDateProvider.notifier).selectPreviousDay();
            },
            heroTag: "previousDay",
            child: const Icon(
              Icons.navigate_before_rounded,
              size: 28,
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              ref.read(selectedDateProvider.notifier).selectNextDay();
            },
            heroTag: "nextDay",
            child: const Icon(
              Icons.navigate_next_rounded,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
