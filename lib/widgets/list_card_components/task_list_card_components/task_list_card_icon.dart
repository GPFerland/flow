import 'package:flow/data/models/routine.dart';
import 'package:flow/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListCardIcon extends ConsumerWidget {
  const TaskListCardIcon({
    super.key,
    required this.task,
    this.routine,
  });

  final Task task;
  final Routine? routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color = task.color;
    if (routine != null) {
      color = routine!.color;
    }

    return Icon(
      task.icon,
      color: color,
      size: 30,
    );
  }
}
