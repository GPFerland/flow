import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local taskInstance data (guest user)
abstract class LocalTaskInstancesRepository {
  Future<TaskInstances> fetchTaskInstances();

  Future<TaskInstance?> fetchTaskInstance(String id);

  Future<void> setTaskInstances(TaskInstances taskInstances);

  Stream<TaskInstances> watchTaskInstances();

  Stream<TaskInstance?> watchTaskInstance(String id);

  Stream<TaskInstances> watchDateTaskInstances(DateTime date);
}

final localTaskInstancesRepositoryProvider =
    Provider<LocalTaskInstancesRepository>((ref) {
  // * Override in main()
  throw UnimplementedError();
});

final localTaskInstancesStreamProvider =
    StreamProvider.autoDispose<TaskInstances>((ref) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.watchTaskInstances();
});

final localTaskInstancesFutureProvider =
    FutureProvider.autoDispose<TaskInstances>((ref) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.fetchTaskInstances();
});

final localTaskInstanceStreamProvider =
    StreamProvider.autoDispose.family<TaskInstance?, String>((ref, id) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.watchTaskInstance(id);
});

final localTaskInstanceFutureProvider =
    FutureProvider.autoDispose.family<TaskInstance?, String>((ref, id) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.fetchTaskInstance(id);
});
