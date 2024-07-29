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
    if (oldIndex == newIndex) {
      return;
    }

    final Task movedTask = tasks.removeAt(oldIndex);
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    tasks.insert(newIndex, movedTask);

    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = tasks[i].setPriority(i);
    }

    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => tasksService.setTasks(tasks),
    );
    if (value.hasValue && !value.hasError) {
      taskInstancesService.updateTaskInstancesPriority(tasks);
    }
    // * only set the state if the controller hasn't been disposed
    if (mounted) {
      state = value;
    }
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
