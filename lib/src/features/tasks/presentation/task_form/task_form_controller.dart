import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormController extends StateNotifier<AsyncValue<void>> {
  TaskFormController({required this.tasksService})
      : super(const AsyncData(null));
  final TasksService tasksService;

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
}

final taskFormControllerProvider =
    StateNotifierProvider.autoDispose<TaskFormController, AsyncValue<void>>(
  (ref) {
    return TaskFormController(
      tasksService: ref.watch(tasksServiceProvider),
    );
  },
);
