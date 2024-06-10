import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
import 'package:flow/src/features/tasks/presentation/edit_task_modal.dart';
import 'package:flow/src/features/tasks/presentation/reschedule_task_modal.dart';
import 'package:flow/src/common_widgets/list_card_components/task_list_card_components/task_list_card_checkbox.dart';
import 'package:flow/src/common_widgets/list_card_components/task_list_card_components/task_list_card_icon.dart';
import 'package:flow/src/common_widgets/list_card_components/task_list_card_components/task_list_card_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckableTaskListCard extends ConsumerWidget {
  const CheckableTaskListCard({
    super.key,
    required this.taskInstance,
    required this.selectedDate,
  });

  final TaskInstance taskInstance;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Task? task =
        ref.read(tasksProvider.notifier).getTaskFromId(taskInstance.taskId);
    Routine? routine = taskInstance.routineId == null
        ? null
        : ref
            .read(routinesProvider.notifier)
            .getRoutineFromId(taskInstance.routineId!);

    final Color? cardColor = taskInstance.completed
        ? (routine?.color ?? task!.color)?.withOpacity(0.1)
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        showScheduleTaskModal(
          context: context,
          task: task,
          taskInstance: taskInstance,
          date: selectedDate,
        );
      },
      onLongPress: () {
        showEditTaskModal(
          context: context,
          task: task,
        );
      },
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            children: [
              TaskListCardIcon(
                task: task!,
                routine: routine,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TaskListCardTitle(
                  task: task,
                  routine: routine,
                ),
              ),
              TaskListCardCheckbox(
                taskInstance: taskInstance,
                selectedDate: selectedDate,
                routine: routine,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
