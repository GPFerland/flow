import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormController extends StateNotifier<AsyncValue<void>> {
  TaskFormController({
    required this.tasksService,
    required this.taskInstancesService,
  }) : super(const AsyncData(null));

  final TasksService tasksService;
  final TaskInstancesService taskInstancesService;

  Future<bool> submitTask(Task task) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => tasksService.setTask(task),
    );
    if (value.hasValue && !value.hasError) {
      return true;
    }
    state = value;
    return state.hasError == false;
  }

  Future<bool> deleteTask(Task task) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => tasksService.removeTask(task),
    );
    if (value.hasValue && !value.hasError) {
      return true;
    }
    state = value;
    return state.hasError == false;
  }

  Future<bool> deleteTasksInstances(Task task) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => taskInstancesService.removeTasksInstances(task.id),
    );
    if (value.hasValue && !value.hasError) {
      return true;
    }
    state = value;
    return state.hasError == false;
  }
}

final taskFormControllerProvider =
    StateNotifierProvider.autoDispose<TaskFormController, AsyncValue<void>>(
  (ref) {
    return TaskFormController(
      tasksService: ref.watch(tasksServiceProvider),
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
    );
  },
);
