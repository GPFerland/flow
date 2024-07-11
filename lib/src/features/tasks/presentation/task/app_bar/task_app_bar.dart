import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/task/app_bar/task_app_bar_actions/delete_task_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskAppBar({
    super.key,
    this.taskId,
  });

  final String? taskId;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: taskId == null
          ? const Text('Create Task')
          : Consumer(
              builder: (context, ref, child) {
                final taskValue = ref.watch(taskStreamProvider(taskId!));
                return AsyncValueWidget(
                  value: taskValue,
                  data: (task) =>
                      task != null ? Text(task.title) : const Text('Task'),
                );
              },
            ),
      actions: taskId == null ? null : [DeleteTaskButton(taskId: taskId!)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
