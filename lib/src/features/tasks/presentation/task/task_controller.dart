import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_controller.g.dart';

@riverpod
class TaskController extends _$TaskController {
  Object? mounted;

  @override
  FutureOr<void> build() {
    mounted = Object();
    ref.onDispose(() => mounted = null);
    // no initialization work to do
  }

  Future<void> submitTask({
    required Task task,
    required Task? oldTask,
    required void Function() onSuccess,
  }) async {
    if (task != oldTask) {
      final tasksService = ref.read(tasksServiceProvider);
      final taskInstancesService = ref.read(taskInstancesServiceProvider);
      state = const AsyncLoading<void>();
      final mounted = this.mounted;
      final value = await AsyncValue.guard(
        () => tasksService.setTasks([task]),
      );
      if (value.hasValue && !value.hasError) {
        taskInstancesService.updateTasksInstances(task, oldTask);
      }
      // * only set the state if the controller hasn't been disposed
      if (mounted == this.mounted) {
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
    final tasksService = ref.read(tasksServiceProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);
    state = const AsyncLoading<void>();
    final mounted = this.mounted;

    AsyncValue<void> value = await AsyncValue.guard(
      () async {
        // * attempt to delete the task instances associated with the task
        await taskInstancesService.removeTasksInstances(taskId);
        // * attempt to delete the task
        await tasksService.removeTask(taskId);
      },
    );

    // * only set the state if the controller hasn't been disposed
    if (mounted == this.mounted) {
      state = value;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}
