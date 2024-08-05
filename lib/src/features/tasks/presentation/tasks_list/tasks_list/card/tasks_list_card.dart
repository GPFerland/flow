import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list/card/components/tasks_list_card_frequency.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list/card/components/tasks_list_card_icon.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//todo - handle the case where the title is too big or the frequency text????
class TasksListCard extends ConsumerWidget {
  const TasksListCard({
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
        context.goNamed(
          AppRoute.editTask.name,
          pathParameters: {'id': task.id},
        );
      },
      child: SizedBox(
        height: taskCardH,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                TasksListCardIcon(task: task),
                const SizedBox(width: 16),
                Expanded(child: Text(task.title)),
                TasksListCardFrequency(task: task),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
