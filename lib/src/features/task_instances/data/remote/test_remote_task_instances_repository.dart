import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRemoteTaskInstancesRepository
    implements RemoteTaskInstancesRepository {
  TestRemoteTaskInstancesRepository({this.addDelay = true});

  final bool addDelay;
  TaskInstances _taskInstances = kTestTaskInstances;

  @override
  Future<TaskInstances> fetchTaskInstances(String userId) async {
    await delay(addDelay);
    return Future.value(_taskInstances);
  }

  @override
  Future<void> setTaskInstances(
    String userId,
    TaskInstances taskInstances,
  ) async {
    _taskInstances = taskInstances;
  }

  @override
  Stream<TaskInstances> watchTaskInstances(String userId) async* {
    await delay(addDelay);
    yield _taskInstances;
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String userId, String id) {
    return watchTaskInstances(userId).map(
      (taskInstances) => taskInstances.taskInstancesList.firstWhereOrNull(
        (task) => task.id == id,
      ),
    );
  }
}

final testRemoteTaskInstancesRepositoryProvider =
    Provider<TestRemoteTaskInstancesRepository>((ref) {
  return TestRemoteTaskInstancesRepository();
});
