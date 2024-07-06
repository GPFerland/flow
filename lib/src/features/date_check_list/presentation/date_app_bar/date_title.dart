import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateTitle extends ConsumerWidget {
  const DateTitle({super.key});

  // Keys for testing using find.byKey()
  static const dateTitleKey = Key('dateTitle');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime date =
        ref.watch(dateStateChangesProvider).value ?? getDateNoTimeToday();

    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await selectDate(
          context: context,
          initialDate: date,
        );
        if (newDate != null) {
          ref.read(dateRepositoryProvider).selectDate(newDate);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Text(
          getTitleDateString(date),
          key: dateTitleKey,
          style: getTitleLargeOnPrimary(context),
        ),
      ),
    );
  }
}
