import 'package:flow/data/models/occurrence.dart';
import 'package:flow/data/models/routine.dart';
import 'package:flow/data/models/task.dart';
import 'package:flow/data/providers/models/occurrences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListCardCheckbox extends ConsumerWidget {
  const TaskListCardCheckbox({
    super.key,
    required this.task,
    required this.selectedDate,
    this.routine,
  });

  final Task task;
  final DateTime selectedDate;
  final Routine? routine;

  Future<void> toggleStatus(
    bool? newValue,
    WidgetRef ref,
    BuildContext context,
  ) async {
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
    bool isEnabled = !selectedDate.isAfter(DateTime.now());

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
