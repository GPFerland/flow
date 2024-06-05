import 'package:flow/data/models/routine.dart';
import 'package:flow/data/models/task.dart';
import 'package:flutter/material.dart';

class RoutineListCardSubtitle extends StatelessWidget {
  const RoutineListCardSubtitle({
    super.key,
    required this.routine,
    required this.date,
    required this.completed,
  });

  final Routine routine;
  final DateTime date;
  final bool completed;

  String getTaskCompletionRatio() {
    int denominator = routine.tasks!.length;
    int numerator = 0;
    for (Task task in routine.tasks!) {
      if (task.isComplete(date)) {
        numerator += 1;
      }
    }
    return '($numerator/$denominator)';
  }

  @override
  Widget build(BuildContext context) {
    return completed
        ? Text(
            'Completed',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: routine.color,
                ),
          )
        : Text(getTaskCompletionRatio());
  }
}
