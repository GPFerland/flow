import 'dart:async';

import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/utils/notifier_mounted.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_list_card_controller.g.dart';

@riverpod
class CheckListCardController extends _$CheckListCardController
    with NotifierMounted {
  late TaskInstance controllerTaskInstance;

  @override
  FutureOr<void> build(TaskInstance taskInstance) {
    ref.onDispose(setUnmounted);
    controllerTaskInstance = taskInstance;
  }

  Future<void> toggleComplete() async {
    final date = ref.read(dateRepositoryProvider).date;
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    state = const AsyncLoading();
    final updatedTaskInstance = controllerTaskInstance.toggleCompleted(date);
    final value = await AsyncValue.guard(
      () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
    );
    _setState(value);
  }

  Future<void> rescheduleTaskInstance({
    required DateTime newDate,
  }) async {
    final taskInstancesService = ref.read(taskInstancesServiceProvider);
    state = const AsyncLoading();
    final updatedTaskInstance = controllerTaskInstance.reschedule(newDate);
    final value = await AsyncValue.guard(
      () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
    );
    _setState(value);
  }

  Future<void> skipTaskInstance() async {
    final dateRepository = ref.read(dateRepositoryProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    state = const AsyncLoading();
    final updatedTaskInstance = controllerTaskInstance.toggleSkipped(
      dateRepository.date,
    );
    final value = await AsyncValue.guard(
      () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
    );
    _setState(value);
  }

  Future<void> deleteTask() async {
    final tasksService = ref.read(tasksServiceProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    state = const AsyncLoading();
    final value = await AsyncValue.guard(() async {
      // * attempt to delete the task instances associated with the task
      await taskInstancesService.deleteTasksInstances(
        controllerTaskInstance.taskId,
      );
      // * attempt to delete the task
      await tasksService.deleteTask(
        controllerTaskInstance.taskId,
      );
    });
    _setState(value);
  }

  void _setState(AsyncValue<void> value) {
    // only set the state if the controller hasn't been disposed
    if (mounted) {
      if (value.hasError) {
        state = AsyncError(value.error!, StackTrace.current);
      } else {
        state = value;
      }
    }
  }
}
