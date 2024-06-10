import 'package:flow/src/features/routine_instances/domain/routine_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineListCardSubtitle extends ConsumerWidget {
  const RoutineListCardSubtitle({
    super.key,
    required this.routineInstance,
    required this.date,
    required this.completed,
  });

  final RoutineInstance routineInstance;
  final DateTime date;
  final bool completed;

  String getTaskCompletionRatio() {
    int denominator = routineInstance.taskInstances!.length;
    int numerator = 0;
    for (TaskInstance taskInstance in routineInstance.taskInstances!) {
      if (taskInstance.completed) {
        numerator += 1;
      }
    }
    return '($numerator/$denominator)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return completed
        ? Text(
            'Completed',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: ref
                      .read(routinesProvider.notifier)
                      .getRoutineColorFromId(routineInstance.routineId),
                ),
          )
        : Text(getTaskCompletionRatio());
  }
}
