import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/task_list/card/task_list_card.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksValue = ref.watch(tasksStreamProvider);

    return AsyncValueWidget(
      value: tasksValue,
      data: (tasks) => tasks.isEmpty
          ? EmptyPlaceholderWidget(
              message: 'Create a task...'.hardcoded,
            )
          : ListView.builder(
              //todo - this is bullshit
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListCard(task: task);
              },
            ),
    );
  }
}
