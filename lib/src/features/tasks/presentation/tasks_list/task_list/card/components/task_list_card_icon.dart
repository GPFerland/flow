import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListCardIcon extends ConsumerWidget {
  const TaskListCardIcon({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Icon(
      task.icon,
      color: task.color,
      size: 30,
    );
  }
}
