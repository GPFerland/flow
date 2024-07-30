import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter/material.dart';

class TasksListCardFrequency extends StatelessWidget {
  const TasksListCardFrequency({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          task.frequencyText,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
