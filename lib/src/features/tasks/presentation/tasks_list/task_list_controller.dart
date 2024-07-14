import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListController extends StateNotifier<AsyncValue<void>> {
  TaskListController({
    required this.tasksService,
    required this.taskInstancesService,
  }) : super(const AsyncData(null));

  final TasksService tasksService;
  final TaskInstancesService taskInstancesService;

  Future<void> reorderTasks(
    List<Task> tasks,
    int oldIndex,
    int newIndex,
  ) async {
    final Task movedTask = tasks.removeAt(oldIndex);
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    tasks.insert(newIndex, movedTask);

    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = tasks[i].setPriority(i);
    }

    await tasksService.setTasks(tasks);
    await taskInstancesService.updateTaskInstancesPriority(tasks);
  }
}

final taskListControllerProvider =
    StateNotifierProvider.autoDispose<TaskListController, AsyncValue<void>>(
  (ref) {
    return TaskListController(
      tasksService: ref.watch(tasksServiceProvider),
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
    );
  },
);
