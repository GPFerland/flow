import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/features/tasks/presentation/task_list_card/task_list_card.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksList extends ConsumerWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksListValue = ref.watch(localTasksStreamProvider);
    return AsyncValueWidget<Tasks>(
      value: tasksListValue,
      data: (tasks) => tasks.tasksList.isEmpty
          ? Center(
              child: Text(
                'No tasks found'.hardcoded,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: Sizes.p8),
              child: ListView.builder(
                //todo - this is not good, figure out the good way to do this.
                shrinkWrap: true,
                itemCount: tasks.tasksList.length,
                itemBuilder: (context, index) {
                  final task = tasks.tasksList[index];
                  return TaskListCard(
                    task: task,
                  );
                },
              ),
            ),
    );
  }
}
