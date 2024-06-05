import 'package:flow/data/models/task.dart';
import 'package:flow/features/edit_task/edit_task_modal.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_frequency.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_icon.dart';
import 'package:flow/widgets/list_card_components/task_list_card_components/task_list_card_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//todo - handle the case where the title is too big or the frequency text????
class ReorderableTaskListCard extends ConsumerWidget {
  const ReorderableTaskListCard({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        showEditTaskModal(
          context: context,
          task: task,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              TaskListCardIcon(
                task: task,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TaskListCardTitle(
                  task: task,
                  showRoutine: true,
                ),
              ),
              TaskListCardFrequency(
                task: task,
              ),
              if (kIsWeb) const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
