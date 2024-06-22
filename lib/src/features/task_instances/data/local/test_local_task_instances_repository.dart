import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestLocalTaskInstancesRepository implements LocalTaskInstancesRepository {
  TestLocalTaskInstancesRepository();
  TaskInstances _taskInstances = kTestTaskInstances;

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
  }

  @override
  Stream<TaskInstances> watchTaskInstances() async* {
    yield _taskInstances;
  }

  @override
  Stream<TaskInstances> watchDateTaskInstances(DateTime date) async* {
    yield _taskInstances;
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
