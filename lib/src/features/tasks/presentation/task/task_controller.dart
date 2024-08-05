import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flow/src/utils/notifier_mounted.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_controller.g.dart';

@riverpod
class TaskController extends _$TaskController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
  }

  Future<void> submitTask({
    required Task task,
    required Task? oldTask,
  }) async {
    if (task != oldTask) {
      // get required services
      final tasksService = ref.read(tasksServiceProvider);
      final taskInstancesService = ref.read(taskInstancesServiceProvider);

      // set the state to loading
      state = const AsyncLoading<void>();

      // if oldTask is null, create new task, otherwise update task
      final value = await AsyncValue.guard(
        () => oldTask == null
            ? tasksService.createTask(task)
            : tasksService.updateTask(task),
      );

      // if no error occurred update the task instances
      if (value.hasValue && !value.hasError) {
        // todo- this function name sucks ass
        await taskInstancesService.changeTasksInstances(task, oldTask);
      }

      // set the state if the controller hasn't been disposed
      if (mounted) {
        if (state.hasError == false) {
          ref.read(goRouterProvider).goNamed(AppRoute.tasks.name);
        } else {
          state = value;
        }
      }
    } else {
      ref.read(goRouterProvider).goNamed(AppRoute.tasks.name);
    }
  }

  Future<void> deleteTask({
    required String taskId,
  }) async {
    // get required services
    final tasksService = ref.read(tasksServiceProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    // set the state to loading
    state = const AsyncLoading<void>();

    // delete task instances associated with the task, then delete the task
    AsyncValue<void> value = await AsyncValue.guard(
      () async {
        // attempt to delete the task instances associated with the task
        await taskInstancesService.deleteTasksInstances(taskId);
        // attempt to delete the task
        await tasksService.deleteTask(taskId);
      },
    );

    // only set the state if the controller hasn't been disposed
    if (mounted) {
      if (state.hasError == false) {
        ref.read(goRouterProvider).goNamed(AppRoute.tasks.name);
      } else {
        state = value;
      }
    }
  }
}
