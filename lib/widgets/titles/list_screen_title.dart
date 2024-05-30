import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreenTitle extends ConsumerWidget {
  const ListScreenTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.watch(selectedDateProvider);

    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await selectDate(
          context: context,
          initialDate: selectedDate,
        );
        if (newDate != null) {
          ref.read(selectedDateProvider.notifier).selectDate(newDate);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          getFormattedDateString(selectedDate),
          key: ValueKey<String>(getFormattedDateString(selectedDate)),
          style: getTitleLargeOnPrimary(context),
        ),
      ),
    );
  }
}
