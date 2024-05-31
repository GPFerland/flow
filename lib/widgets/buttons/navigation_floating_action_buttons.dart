import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/widgets/buttons/show_completed_items_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationFloatingActionButtons extends ConsumerWidget {
  const NavigationFloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: FloatingActionButton(
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
          ),
          const Flexible(
            flex: 4,
            child: ShowCompletedItemsButton(),
          ),
          Flexible(
            flex: 1,
            child: FloatingActionButton(
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
          ),
        ],
      ),
    );
  }
}
