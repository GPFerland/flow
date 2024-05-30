import 'package:flow/models/task.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_frequency.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_icon.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/task_list_tile_components/task_list_tile_title.dart';
import 'package:flow/widgets/modals/edit_task_modal.dart';
import 'package:flutter/material.dart';

//todo - handle the case where the title is too big or the frequency text????
class ReorderableTaskListTile extends StatelessWidget {
  const ReorderableTaskListTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showEditTaskModal(
              context: context,
              task: task,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            height: listTileHeight,
            child: Row(
              children: [
                TaskListTileIcon(
                  task: task,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TaskListTileTitle(
                    task: task,
                    showRoutine: true,
                  ),
                ),
                TaskListTileFrequency(
                  task: task,
                ),
              ],
            ),
          ),
        ),
        const DividerOnPrimaryContainer(),
      ],
    );
  }
}
