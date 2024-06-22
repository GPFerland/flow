import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/task_list_card/task_list_card_components/task_list_card_icon.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//todo - handle the case where the title is too big or the frequency text????
class TaskInstanceListCard extends ConsumerWidget {
  const TaskInstanceListCard({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(taskProvider(taskInstance.taskId));

    return AsyncValueWidget<Task?>(
      value: taskValue,
      data: (task) {
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            context.goNamed(
              AppRoute.editTask.name,
              pathParameters: {'id': task.id},
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  TaskListCardIcon(
                    task: task!,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(task.title),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
