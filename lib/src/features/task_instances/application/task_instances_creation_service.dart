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
    // listen for changes of the date
    ref.listen<AsyncValue<DateTime>>(
      dateStreamProvider,
      (previous, next) {
        // if the date value is new
        if (next.value != null && previous?.value != next.value) {
          // create the task instances for the date, day before, and day after
          _createTaskInstances([
            next.value!,
            next.value!.subtract(const Duration(days: 1)),
            next.value!.add(const Duration(days: 1)),
          ]);
        }
      },
    );
  }

  Future<void> _createTaskInstances(List<DateTime> dates) async {
    try {
      final taskInstancesService = ref.read(taskInstancesServiceProvider);

      final tasks = await ref.read(tasksFutureProvider.future);

      // attempt to create a task instances for each task on the dates
      for (Task task in tasks) {
        await taskInstancesService.createTasksInstances(task, dates);
      }
    } catch (exception, stackTrace) {
      //todo - should this be a custom exception
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
