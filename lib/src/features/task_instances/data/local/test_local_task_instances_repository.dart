import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class TestLocalTaskInstancesRepository implements LocalTaskInstancesRepository {
  TestLocalTaskInstancesRepository();
  TaskInstances _taskInstances = TaskInstances(taskInstancesList: []);

  final _taskInstancesStreamController = BehaviorSubject<TaskInstances>.seeded(
    TaskInstances(taskInstancesList: []),
  );

  @override
  Future<TaskInstances> fetchTaskInstances() async {
    return Future.value(_taskInstances);
  }

  @override
  Future<TaskInstance?> fetchTaskInstance(String id) async {
    return Future.value(
      _taskInstances.taskInstancesList
          .firstWhereOrNull((taskInstance) => taskInstance.id == id),
    );
  }

  @override
  Future<void> setTaskInstances(TaskInstances taskInstances) async {
    _taskInstances = taskInstances;
    _taskInstancesStreamController.add(taskInstances);
  }

  @override
  Stream<TaskInstances> watchTaskInstances() {
    return _taskInstancesStreamController.stream;
  }

  @override
  Stream<TaskInstances> watchDateTaskInstances(DateTime date) {
    return watchTaskInstances().map((taskInstances) {
      final filteredInstances =
          taskInstances.taskInstancesList.where((taskInstance) {
        return date == taskInstance.completedDate ||
            date == taskInstance.skippedDate ||
            date == taskInstance.rescheduledDate ||
            (date == taskInstance.initialDate &&
                taskInstance.rescheduledDate == null);
      }).toList();
      return TaskInstances(taskInstancesList: filteredInstances);
    });
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String id) {
    return watchTaskInstances().map(
      (taskInstances) => taskInstances.taskInstancesList
          .firstWhereOrNull((taskInstance) => taskInstance.id == id),
    );
  }
}

final testLocalTaskInstancesRepositoryProvider =
    Provider<TestLocalTaskInstancesRepository>((ref) {
  return TestLocalTaskInstancesRepository();
});
