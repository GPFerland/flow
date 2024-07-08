import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/delete_task_button.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the task page.
class TaskScreen extends ConsumerWidget {
  const TaskScreen({
    super.key,
    this.taskId,
  });

  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = taskId == null
        ? const AsyncData(null)
        : ref.watch(taskFutureProvider(taskId!));

    return AsyncValueWidget<Task?>(
      value: taskValue,
      data: (task) => Scaffold(
        appBar: AppBar(
          title: task == null ? const Text('Create Task') : Text(task.title),
          actions: task == null ? null : [DeleteTaskButton(task: task)],
        ),
        body: CustomScrollView(
          slivers: [
            ResponsiveSliverCenter(
              padding: const EdgeInsets.all(Sizes.p4),
              child: TaskForm(task: task),
            ),
          ],
        ),
      ),
    );
  }
}
