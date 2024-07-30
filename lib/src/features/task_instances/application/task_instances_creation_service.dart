import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_instances_creation_service.g.dart';

class TaskInstancesCreationService {
  TaskInstancesCreationService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<DateTime>>(
      dateStreamProvider,
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
    try {
      final tasksService = ref.read(tasksServiceProvider);
      final taskInstancesService = ref.read(taskInstancesServiceProvider);

      final tasks = await tasksService.fetchTasks();

      for (Task task in tasks) {
        await taskInstancesService.createTaskInstances(task, [date]);
      }
    } catch (exception, stackTrace) {
      ref.read(errorLoggerProvider).logError(exception, stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
TaskInstancesCreationService taskInstancesCreationService(
  TaskInstancesCreationServiceRef ref,
) {
  return TaskInstancesCreationService(ref);
}
