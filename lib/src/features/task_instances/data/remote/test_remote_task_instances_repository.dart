import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRemoteTaskInstancesRepository
    implements RemoteTaskInstancesRepository {
  TestRemoteTaskInstancesRepository();

  TaskInstances _taskInstances = kTestTaskInstances;

  @override
  Future<TaskInstances> fetchTaskInstances(String uid) async {
    return Future.value(_taskInstances);
  }

  @override
  Future<void> setTaskInstances(
      String userId, TaskInstances taskInstances) async {
    _taskInstances = taskInstances;
  }

  @override
  Stream<TaskInstances> watchTaskInstances(String uid) async* {
    yield _taskInstances;
  }

  @override
  Stream<TaskInstances> watchDateTaskInstances(
      String uid, DateTime date) async* {
    yield _taskInstances;
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String uid, String id) {
    return watchTaskInstances(uid).map(
      (taskInstances) => taskInstances.taskInstancesList
          .firstWhereOrNull((taskInstance) => taskInstance.id == id),
    );
  }
}

final testRemoteTaskInstancesRepositoryProvider =
    Provider<TestRemoteTaskInstancesRepository>(
  (ref) {
    return TestRemoteTaskInstancesRepository();
  },
);

final testRemoteTaskInstancesListStreamProvider =
    StreamProvider.autoDispose.family<TaskInstances, String>(
  (ref, uid) {
    final taskInstancesRepository =
        ref.watch(testRemoteTaskInstancesRepositoryProvider);
    return taskInstancesRepository.watchTaskInstances(uid);
  },
);

final testRemoteTaskInstancesListFutureProvider =
    FutureProvider.autoDispose.family<TaskInstances, String>(
  (ref, uid) {
    final taskInstancesRepository =
        ref.watch(testRemoteTaskInstancesRepositoryProvider);
    return taskInstancesRepository.fetchTaskInstances(uid);
  },
);

final testRemoteTaskInstanceStreamProvider =
    StreamProvider.autoDispose.family<TaskInstance?, RemoteItem>(
  (ref, remoteItem) {
    final taskInstancesRepository =
        ref.watch(testRemoteTaskInstancesRepositoryProvider);
    return taskInstancesRepository.watchTaskInstance(
        remoteItem.userId, remoteItem.itemId);
  },
);
