import 'package:flow/data/models/occurrence.dart';
import 'package:flow/data/models/task.dart';
import 'package:flow/data/providers/models/occurrences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescheduleTaskButton extends ConsumerWidget {
  const RescheduleTaskButton({
    super.key,
    required this.task,
    required this.date,
    required this.rescheduledDate,
  });

  final Task task;
  final DateTime date;
  final DateTime rescheduledDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? originalDate = task.getMostRecentScheduledDate(date);

    void rescheduleTask() {
      Occurrence newOccurrence = Occurrence(
        taskId: task.id,
        completed: false,
        originalDate: originalDate,
        rescheduledDate: rescheduledDate,
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
          originalDate!,
        );
        if (matchingOccurrence == null) {
          ref.read(occurrencesProvider.notifier).createOccurrence(
                newOccurrence,
                context,
              );
        } else {
          matchingOccurrence.rescheduledDate = rescheduledDate;
          ref.read(occurrencesProvider.notifier).updateOccurrence(
                matchingOccurrence,
                context,
              );
        }
      }
    }

    return ElevatedButton(
      onPressed: () {
        rescheduleTask();
        Navigator.of(context).pop(true);
      },
      child: const Text('Save'),
    );
  }
}
