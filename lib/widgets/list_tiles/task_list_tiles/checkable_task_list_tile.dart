import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/dividers/divider_routine.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_checkbox.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_icon.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_title.dart';
import 'package:flow/widgets/modals/edit_task_modal.dart';
import 'package:flow/widgets/modals/reschedule_task_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckableTaskListTile extends ConsumerWidget {
  const CheckableTaskListTile({
    super.key,
    required this.task,
    this.routine,
    this.isCheckable = true,
  });

  final Task task;
  final Routine? routine;
  final bool isCheckable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.read(selectedDateProvider);
    bool completed = task.isComplete(selectedDate);
    final Color? tileColor =
        completed ? (routine?.color ?? task.color)?.withOpacity(0.1) : null;

    return Column(
      children: [
        InkWell(
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
          child: Container(
            height: listTileHeight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(color: tileColor),
            child: Row(
              children: [
                TaskListTileIcon(
                  task: task,
                  routine: routine,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TaskListTileTitle(
                    task: task,
                    routine: routine,
                  ),
                ),
                TaskListTileCheckbox(
                  task: task,
                  routine: routine,
                  isCheckable: isCheckable,
                ),
              ],
            ),
          ),
        ),
        if (routine != null &&
            routine!.tasks != null &&
            routine!.tasks!.isNotEmpty &&
            routine!.tasks!.last == task)
          DividerForRoutine(routine: routine!),
      ],
    );
  }
}
