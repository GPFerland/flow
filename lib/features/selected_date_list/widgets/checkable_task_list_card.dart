import 'package:flow/data/models/routine.dart';
import 'package:flow/data/models/task.dart';
import 'package:flow/features/edit_task/edit_task_modal.dart';
import 'package:flow/features/reschedule_task/reschedule_task_modal.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_checkbox.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_icon.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckableTaskListCard extends ConsumerWidget {
  const CheckableTaskListCard({
    super.key,
    required this.task,
    required this.selectedDate,
    this.routine,
  });

  final Task task;
  final DateTime selectedDate;
  final Routine? routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool completed = task.isComplete(selectedDate);
    final Color? cardColor =
        completed ? (routine?.color ?? task.color)?.withOpacity(0.1) : null;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        showScheduleTaskModal(
          context: context,
          task: task,
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
                task: task,
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
                task: task,
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
