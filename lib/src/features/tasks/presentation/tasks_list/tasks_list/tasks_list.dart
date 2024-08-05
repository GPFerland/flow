import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list/card/tasks_list_card.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list_controller.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksList extends ConsumerWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final remoteTasksRepository = ref.watch(remoteTasksRepositoryProvider);
    // return FirestoreListView<Task>(
    //   query: remoteTasksRepository.tasksQuery(),
    //   itemBuilder: (
    //     BuildContext context,
    //     QueryDocumentSnapshot<Task> doc,
    //   ) {
    //     final task = doc.data();
    //     return TasksListCard(
    //       key: ValueKey(task.id),
    //       task: task,
    //     );
    //   },
    // );

    final tasksValue = ref.watch(tasksStreamProvider);
    final state = ref.watch(tasksListControllerProvider);

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
                return TasksListCard(
                  key: ValueKey(tasks[index].id),
                  task: tasks[index],
                );
              },
              buildDefaultDragHandles: !state.isLoading,
              onReorder: (oldIndex, newIndex) {
                ref.read(tasksListControllerProvider.notifier).reorderTasks(
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
