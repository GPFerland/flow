import 'package:flow/src/common_widgets/FUCK/providers/date/selected_date_provider.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListTitle extends ConsumerWidget {
  const CheckListTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.watch(dateProvider);

    //todo - lots of this logic is reused in the floating action buttons, fix it
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await selectDate(
          context: context,
          initialDate: selectedDate,
        );
        if (newDate != null) {
          ref.read(dateProvider.notifier).selectDate(newDate);
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
