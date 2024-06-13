import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing remote taskInstance
abstract class RemoteTaskInstancesRepository {
  Future<TaskInstances> fetchTaskInstances(String userId);

  Future<void> setTaskInstances(String userId, TaskInstances taskInstances);

  Stream<TaskInstances> watchTaskInstances(String userId);

  Stream<TaskInstance?> watchTaskInstance(String userId, String id);
}

final remoteTaskInstancesRepositoryProvider =
    Provider<RemoteTaskInstancesRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTaskInstancesStreamProvider =
    StreamProvider.autoDispose.family<TaskInstances, String>((ref, userId) {
  final tasksRepository = ref.watch(remoteTaskInstancesRepositoryProvider);
  return tasksRepository.watchTaskInstances(userId);
});

final remoteTaskInstancesFutureProvider =
    FutureProvider.autoDispose.family<TaskInstances, String>((ref, userId) {
  final tasksRepository = ref.watch(remoteTaskInstancesRepositoryProvider);
  return tasksRepository.fetchTaskInstances(userId);
});

final remoteTaskInstanceStreamProvider = StreamProvider.autoDispose
    .family<TaskInstance?, RemoteItem>((ref, remoteItem) {
  final tasksRepository = ref.watch(remoteTaskInstancesRepositoryProvider);
  return tasksRepository.watchTaskInstance(
    remoteItem.userId,
    remoteItem.itemId,
  );
});
