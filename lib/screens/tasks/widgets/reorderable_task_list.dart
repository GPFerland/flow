import 'package:flow/models/task.dart';
import 'package:flow/providers/models/tasks_provider.dart';
import 'package:flow/screens/tasks/widgets/reorderable_task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReorderableTaskList extends ConsumerWidget {
  const ReorderableTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> tasks = ref.watch(tasksProvider);

    return ReorderableListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ReorderableTaskListTile(
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
    );
  }
}
