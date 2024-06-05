import 'package:flow/data/models/task.dart';
import 'package:flow/data/providers/models/tasks_provider.dart';
import 'package:flow/features/tasks_list/widgets/reorderable_task_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReorderableTaskList extends ConsumerWidget {
  const ReorderableTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> tasks = ref.watch(tasksProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ReorderableTaskListCard(
            key: ValueKey(tasks[index].id),
            task: tasks[index],
          );
        },
        onReorder: (oldIndex, newIndex) {
          //todo - I think this is duplicated in the routines list and could be in
          // a function or something?????
          final Task movedTask = tasks.removeAt(oldIndex);
          newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
          tasks.insert(newIndex, movedTask);

          for (int i = 0; i < tasks.length; i++) {
            tasks[i].setPriority(i);
          }

          ref.read(tasksProvider.notifier).updateTasks(tasks, context);
        },
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Material(
                elevation: 12 * Curves.easeInOut.transform(animation.value),
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
