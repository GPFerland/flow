import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteTaskInstancesRepository {
  Future<TaskInstances> fetchTaskInstances(String uid);

  Future<void> setTaskInstances(String uid, TaskInstances taskInstances);

  Stream<TaskInstances> watchTaskInstances(String uid);

  Stream<TaskInstance?> watchTaskInstance(String uid, String taskInstanceId);

  Stream<TaskInstances> watchDateTaskInstances(String uid, DateTime date);
}

final remoteTaskInstancesRepositoryProvider =
    Provider<RemoteTaskInstancesRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTaskInstancesListStreamProvider =
    StreamProvider.autoDispose.family<List<TaskInstance>, String>((ref, uid) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTaskInstancesListFutureProvider =
    FutureProvider.autoDispose.family<List<TaskInstance>, String>((ref, uid) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTaskInstanceStreamProvider = StreamProvider.autoDispose
    .family<TaskInstance?, RemoteItem>((ref, remoteItem) {
  // * Override this in the main method
  throw UnimplementedError();
});
