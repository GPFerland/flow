import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/providers/models/routines_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTileTitle extends ConsumerWidget {
  const TaskListTileTitle({
    super.key,
    required this.task,
    this.routine,
    this.showRoutine = false,
  });

  final Task task;
  final Routine? routine;
  final bool showRoutine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color = routine != null ? routine!.color : task.color;
    String? routineTitle;

    if (showRoutine && task.routineId != null) {
      if (routine != null) {
        routineTitle = routine!.title;
      } else {
        routineTitle =
            ref.read(routinesProvider.notifier).getRoutineTitleFromId(
                  task.routineId!,
                );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          task.title!,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: color,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        if (routineTitle != null)
          Text(
            routineTitle,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
