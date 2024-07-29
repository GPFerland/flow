import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskController extends StateNotifier<AsyncValue<void>> {
  TaskController({
    required this.tasksService,
    required this.taskInstancesService,
  }) : super(const AsyncData(null));

  final TasksService tasksService;
  final TaskInstancesService taskInstancesService;

  Future<void> submitTask({
    required Task task,
    required Task? oldTask,
    required void Function() onSuccess,
  }) async {
    if (task != oldTask) {
      state = const AsyncLoading<void>();
      final value = await AsyncValue.guard(
        () => tasksService.setTasks([task]),
      );
      if (value.hasValue && !value.hasError) {
        taskInstancesService.updateTasksInstances(task, oldTask);
      }
      // * only set the state if the controller hasn't been disposed
      if (mounted) {
        state = value;
        if (state.hasError == false) {
          onSuccess();
        }
      }
    } else {
      onSuccess();
    }
  }

  Future<void> deleteTask({
    required String taskId,
    required void Function() onSuccess,
  }) async {
    state = const AsyncLoading<void>();

    final value = await AsyncValue.guard(
      () async {
        // * attempt to delete the task instances associated with the task
        await taskInstancesService.removeTasksInstances(taskId);
        // * attempt to delete the task
        await tasksService.removeTask(taskId);
      },
    );

    // * only set the state if the controller hasn't been disposed
    if (mounted) {
      state = value;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}

final taskControllerProvider =
    StateNotifierProvider.autoDispose<TaskController, AsyncValue<void>>(
  (ref) {
    return TaskController(
      tasksService: ref.watch(tasksServiceProvider),
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
    );
  },
);
