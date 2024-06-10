import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListCardCheckbox extends ConsumerWidget {
  const TaskListCardCheckbox({
    super.key,
    required this.taskInstance,
    required this.selectedDate,
    this.routine,
  });

  final TaskInstance taskInstance;
  final DateTime selectedDate;
  final Routine? routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isEnabled = !selectedDate.isAfter(DateTime.now());

    Task? task = ref.read(tasksProvider.notifier).getTaskFromId(
          taskInstance.taskId,
        );

    return Checkbox(
      value: taskInstance.completed,
      onChanged: isEnabled
          ? (bool? value) {
              taskInstance.toggleCompleted();
              if (taskInstance.completed) {
                taskInstance.completedDate = selectedDate;
              } else {
                taskInstance.completedDate = null;
              }
              ref.read(taskInstancesProvider.notifier).updateTaskInstance(
                    taskInstance,
                    context,
                  );
            }
          : null,
      activeColor: routine != null ? routine!.color : task!.color,
    );
  }
}
