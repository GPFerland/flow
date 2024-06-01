import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTileIcon extends ConsumerWidget {
  const TaskListTileIcon({
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
