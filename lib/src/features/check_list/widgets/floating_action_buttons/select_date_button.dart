import 'package:flow/src/common_widgets/FUCK/providers/date/selected_date_provider.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectDateButton extends ConsumerWidget {
  const SelectDateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.watch(dateProvider);

    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          getFormattedDateString(selectedDate),
          key: ValueKey<String>(getFormattedDateString(selectedDate)),
          style: getTitleLargeOnPrimaryContainer(context),
        ),
      ),
      onPressed: () async {
        DateTime? newDate = await selectDate(
          context: context,
          initialDate: selectedDate,
        );
        if (newDate != null) {
          ref.read(dateProvider.notifier).selectDate(newDate);
        }
      },
    );
  }
}
