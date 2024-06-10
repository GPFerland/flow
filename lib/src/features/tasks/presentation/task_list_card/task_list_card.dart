import 'package:flow/src/features/tasks/presentation/task_list_card/task_list_card_components/task_list_card_icon.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//todo - handle the case where the title is too big or the frequency text????
class TaskListCard extends ConsumerWidget {
  const TaskListCard({
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
          AppRoute.task.name,
          pathParameters: {'id': task.id},
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
                child: Text(task.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
