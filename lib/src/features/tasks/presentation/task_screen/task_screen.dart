import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_app_bar/task_app_bar.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_form.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({
    super.key,
    this.taskId,
  });

  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      taskControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: TaskAppBar(taskId: taskId),
      body: CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p4),
            child: Consumer(
              builder: (context, ref, child) {
                final taskValue = taskId == null
                    ? const AsyncData(null)
                    : ref.watch(taskStreamProvider(taskId!));

                return AsyncValueWidget(
                  value: taskValue,
                  data: (task) => TaskForm(task: task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
