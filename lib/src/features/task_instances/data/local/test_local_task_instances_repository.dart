import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestLocalTaskInstancesRepository implements LocalTaskInstancesRepository {
  TestLocalTaskInstancesRepository({this.addDelay = true});

  final bool addDelay;
  TaskInstances _taskInstances = kTestTaskInstances;

  @override
  Future<TaskInstances> fetchTaskInstances() async {
    await delay(addDelay);
    return Future.value(_taskInstances);
  }

  @override
  Future<void> setTaskInstances(TaskInstances taskInstances) async {
    _taskInstances = taskInstances;
  }

  @override
  Stream<TaskInstances> watchTaskInstances() async* {
    await delay(addDelay);
    yield _taskInstances;
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String id) {
    return watchTaskInstances().map(
      (tasks) => tasks.taskInstancesList.firstWhereOrNull(
        (task) => task.id == id,
      ),
    );
  }
}

final testLocalTaskInstancesRepositoryProvider =
    Provider<TestLocalTaskInstancesRepository>((ref) {
  return TestLocalTaskInstancesRepository();
});
