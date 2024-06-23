import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListCardCheckbox extends ConsumerWidget {
  const TaskListCardCheckbox({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime date =
        ref.watch(dateStateChangesProvider).value ?? getDateNoTimeToday();

    bool isEnabled = !date.isAfter(getDateNoTimeToday());

    return Checkbox(
      value: taskInstance.completed,
      onChanged: isEnabled
          ? (bool? value) {
              final updatedTaskInstance = taskInstance.toggleCompleted(date);
              ref.read(taskInstancesServiceProvider).setTaskInstance(
                    updatedTaskInstance,
                  );
            }
          : null,
      activeColor: null,
    );
  }
}
