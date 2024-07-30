import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_list_controller.g.dart';

@riverpod
class TasksListController extends _$TasksListController {
  Object? mounted;

  @override
  FutureOr<void> build() {
    mounted = Object();
    ref.onDispose(() => mounted = null);
    // no initialization work to do
  }

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

    final tasksService = ref.read(tasksServiceProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);
    state = const AsyncLoading<void>();
    final mounted = this.mounted;
    final value = await AsyncValue.guard(
      () => tasksService.setTasks(tasks),
    );
    if (value.hasValue && !value.hasError) {
      taskInstancesService.updateTaskInstancesPriority(tasks);
    }
    // * only set the state if the controller hasn't been disposed
    if (mounted == this.mounted) {
      state = value;
    }
  }
}
