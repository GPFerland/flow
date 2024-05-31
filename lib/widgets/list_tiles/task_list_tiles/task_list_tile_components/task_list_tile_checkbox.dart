import 'package:flow/models/occurrence.dart';
import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/providers/models/occurrences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTileCheckbox extends ConsumerWidget {
  const TaskListTileCheckbox({
    super.key,
    required this.task,
    this.routine,
    this.isCheckable = true,
  });

  final Task task;
  final Routine? routine;
  final bool isCheckable;

  Future<void> toggleStatus(
      bool? newValue, WidgetRef ref, BuildContext context) async {
    DateTime selectedDate = ref.read(selectedDateProvider);

    Occurrence newOccurrence = Occurrence(
      taskId: task.id,
      completed: true,
      originalDate:
          task.getMostRecentScheduledDate(selectedDate) ?? selectedDate,
      completedDate: selectedDate,
      skipped: false,
    );

    if (task.occurrences == null) {
      ref.read(occurrencesProvider.notifier).createOccurrence(
            newOccurrence,
            context,
          );
    } else {
      Occurrence? matchingOccurrence = getMatchingOccurrence(
        task.occurrences!,
        selectedDate,
      );
      if (matchingOccurrence == null) {
        ref.read(occurrencesProvider.notifier).createOccurrence(
              newOccurrence,
              context,
            );
      } else {
        matchingOccurrence.completed = !matchingOccurrence.completed!;
        ref.read(occurrencesProvider.notifier).updateOccurrence(
              matchingOccurrence,
              context,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.read(selectedDateProvider);
    bool isEnabled = !selectedDate.isAfter(DateTime.now()) && isCheckable;

    return Checkbox(
      value: task.isComplete(selectedDate),
      onChanged: isEnabled
          ? (value) => toggleStatus(
                value,
                ref,
                context,
              )
          : null,
      activeColor: routine != null ? routine!.color : task.color,
    );
  }
}
