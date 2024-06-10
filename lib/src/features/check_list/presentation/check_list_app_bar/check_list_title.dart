import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListTitle extends ConsumerWidget {
  const CheckListTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime date = getDateNoTimeToday();

    //todo - lots of this logic is reused in the floating action buttons, fix it
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await selectDate(
          context: context,
          initialDate: date,
        );
        if (newDate != null) {}
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          getFormattedDateString(date),
          key: ValueKey<String>(getFormattedDateString(date)),
          style: getTitleLargeOnPrimary(context),
        ),
      ),
    );
  }
}
