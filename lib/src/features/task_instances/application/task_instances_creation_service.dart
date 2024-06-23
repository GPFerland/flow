import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskInstancesCreationService {
  TaskInstancesCreationService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<DateTime>>(
      dateStateChangesProvider,
      (previous, next) {
        if (next.value != null && previous?.value != next.value) {
          _createTaskInstances(next.value!);
          _createTaskInstances(next.value!.subtract(const Duration(days: 1)));
          _createTaskInstances(next.value!.add(const Duration(days: 1)));
        }
      },
    );
  }

  Future<void> _createTaskInstances(DateTime date) async {
    final tasksService = ref.read(tasksServiceProvider);
    final tasks = await tasksService.fetchTasks();
    for (Task task in tasks.tasksList) {
      await ref
          .read(taskInstancesServiceProvider)
          .createTaskInstance(task, date);
    }
  }
}

final taskInstancesCreationServiceProvider =
    Provider<TaskInstancesCreationService>(
  (ref) {
    return TaskInstancesCreationService(ref);
  },
);
