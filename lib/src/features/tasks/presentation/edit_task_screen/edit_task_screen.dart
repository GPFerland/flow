import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/tasks/presentation/edit_task_screen/delete_task_button.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the task page for a given task Id.
class EditTaskScreen extends ConsumerWidget {
  const EditTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(localTaskStreamProvider(taskId));
    return Scaffold(
      appBar: AppBar(
        title: taskValue.value == null
            ? const Text('Task')
            : Text(taskValue.value!.title),
        actions: taskValue.value == null
            ? null
            : [DeleteTaskButton(task: taskValue.value!)],
      ),
      body: AsyncValueWidget<Task?>(
        value: taskValue,
        data: (task) => task == null
            ? EmptyPlaceholderWidget(
                message: 'Task not found'.hardcoded,
              )
            : CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: TaskForm(task: task),
                  ),
                ],
              ),
      ),
    );
  }
}
