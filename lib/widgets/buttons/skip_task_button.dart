import 'package:flow/data/models/occurrence.dart';
import 'package:flow/data/models/task.dart';
import 'package:flow/data/providers/models/occurrences_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkipTaskButton extends ConsumerWidget {
  const SkipTaskButton({
    super.key,
    required this.task,
    required this.date,
  });

  final Task task;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void skipTask() {
      Occurrence newOccurrence = Occurrence(
        taskId: task.id,
        completed: false,
        originalDate: task.getMostRecentScheduledDate(date),
        skippedDate: date,
        skipped: true,
      );

      if (task.occurrences == null) {
        ref.read(occurrencesProvider.notifier).createOccurrence(
              newOccurrence,
              context,
            );
      } else {
        Occurrence? matchingOccurrence = getMatchingOccurrence(
          task.occurrences!,
          date,
        );
        if (matchingOccurrence == null) {
          ref.read(occurrencesProvider.notifier).createOccurrence(
                newOccurrence,
                context,
              );
        } else {
          matchingOccurrence.skipped = true;
          ref.read(occurrencesProvider.notifier).updateOccurrence(
                matchingOccurrence,
                context,
              );
        }
      }
    }

    return ElevatedButton(
      child: const Text('Skip Task'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Skip Task',
                      style: getTitleLargeOnPrimaryContainer(context),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Are you sure you want to skip the \n${task.title} task?',
                      textAlign: TextAlign.center,
                      style: getBodyLargeOnPrimaryContainer(context),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            skipTask();
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Skip'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ).then((value) {
          if (value == true) {
            Navigator.pop(context);
          }
        });
      },
    );
  }
}
