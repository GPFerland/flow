import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/date_check_list/presentation/reschedule_dialog/reschedule_dialog.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/task_list_card/task_list_card_components/task_list_card_checkbox.dart';
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
    final taskValue = ref.watch(taskStreamProvider(taskInstance.taskId));

    return AsyncValueWidget<Task?>(
      value: taskValue,
      data: (task) {
        return InkWell(
          borderRadius: BorderRadius.circular(Sizes.p12),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p12),
          ),
          onTap: () {
            showRescheduleDialog(
              context: context,
              taskInstance: taskInstance,
            );
          },
          onLongPress: () {
            context.pushNamed(
              AppRoute.editTask.name,
              pathParameters: {'id': task.id},
            );
          },
          child: Card(
            //todo - this is fucked
            color: taskInstance.completed || taskInstance.skipped
                ? taskInstance.completed
                    ? Colors.grey[400]
                    : Colors.grey[500]
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.p12,
                horizontal: Sizes.p16,
              ),
              child: Row(
                children: [
                  TaskListCardIcon(
                    task: task!,
                  ),
                  gapW16,
                  Expanded(
                    child: Text(
                      task.title,
                    ),
                  ),
                  TaskListCardCheckbox(
                    taskInstance: taskInstance,
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
