import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskController extends StateNotifier<AsyncValue<void>> {
  TaskController({
    required this.tasksService,
    required this.taskInstancesService,
    required this.dateRepository,
  }) : super(const AsyncData(null));

  final TasksService tasksService;
  final TaskInstancesService taskInstancesService;
  final DateRepository dateRepository;

  Future<void> submitTask({
    required Task task,
    required Task? oldTask,
    required void Function() onSuccess,
  }) async {
    if (task != oldTask) {
      state = const AsyncLoading<void>();
      final value = await AsyncValue.guard(
        () => tasksService.setTask(task),
      );
      if (value.hasValue && !value.hasError) {
        await taskInstancesService.createTaskInstance(
          task,
          dateRepository.dateBefore,
        );
        await taskInstancesService.createTaskInstance(
          task,
          dateRepository.date,
        );
        await taskInstancesService.createTaskInstance(
          task,
          dateRepository.dateAfter,
        );
      }
      if (mounted) {
        // * only set the state if the controller hasn't been disposed
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
    required Task task,
    required void Function() onSuccess,
  }) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => tasksService.removeTask(task),
    );
    if (mounted) {
      // * only set the state if the controller hasn't been disposed
      state = value;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }

  Future<void> deleteTasksInstances({
    required Task task,
    required void Function() onSuccess,
  }) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => taskInstancesService.removeTasksInstances(task.id),
    );
    if (mounted) {
      // * only set the state if the controller hasn't been disposed
      state = value;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}

final taskFormControllerProvider =
    StateNotifierProvider.autoDispose<TaskController, AsyncValue<void>>(
  (ref) {
    return TaskController(
      tasksService: ref.watch(tasksServiceProvider),
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
      dateRepository: ref.watch(dateRepositoryProvider),
    );
  },
);
