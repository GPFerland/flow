import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/task_list/card/task_list_card.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/task_list_controller.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksValue = ref.watch(tasksStreamProvider);
    final state = ref.watch(taskListControllerProvider);

    return AsyncValueWidget(
      value: tasksValue,
      data: (tasks) => tasks.isEmpty
          ? EmptyPlaceholderWidget(
              message: 'Create a task...'.hardcoded,
            )
          : ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskListCard(
                  key: ValueKey(tasks[index].id),
                  task: tasks[index],
                );
              },
              buildDefaultDragHandles: !state.isLoading,
              onReorder: (oldIndex, newIndex) {
                ref.read(taskListControllerProvider.notifier).reorderTasks(
                      tasks,
                      oldIndex,
                      newIndex,
                    );
              },
              proxyDecorator: (
                Widget child,
                int index,
                Animation<double> animation,
              ) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Material(
                      elevation:
                          12 * Curves.easeInOut.transform(animation.value),
                      borderRadius: BorderRadius.circular(12),
                      child: child!,
                    );
                  },
                  child: child,
                );
              },
            ),
    );
  }
}
