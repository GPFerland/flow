import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/notifier_mounted.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_list_controller.g.dart';

@riverpod
class TasksListController extends _$TasksListController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
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
    final value = await AsyncValue.guard(
      () => tasksService.updateTasks(tasks),
    );
    if (value.hasValue && !value.hasError) {
      taskInstancesService.updateTaskInstancesPriority(tasks);
    }
    if (mounted) {
      state = value;
    }
  }
}
