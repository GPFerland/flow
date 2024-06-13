import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local taskInstance data (guest user)
abstract class LocalTaskInstancesRepository {
  Future<TaskInstances> fetchTaskInstances();

  Future<void> setTaskInstances(TaskInstances taskInstances);

  Stream<TaskInstances> watchTaskInstances();

  Stream<TaskInstance?> watchTaskInstance(String id);
}

final localTaskInstancesRepositoryProvider =
    Provider<LocalTaskInstancesRepository>((ref) {
  // * Override in main()
  throw UnimplementedError();
});

final localTaskInstancesStreamProvider =
    StreamProvider.autoDispose<TaskInstances>((ref) {
  final tasksRepository = ref.watch(localTaskInstancesRepositoryProvider);
  return tasksRepository.watchTaskInstances();
});

final localTaskInstancesFutureProvider =
    FutureProvider.autoDispose<TaskInstances>((ref) {
  final tasksRepository = ref.watch(localTaskInstancesRepositoryProvider);
  return tasksRepository.fetchTaskInstances();
});

final localTaskInstanceStreamProvider =
    StreamProvider.autoDispose.family<TaskInstance?, String>((ref, id) {
  final tasksRepository = ref.watch(localTaskInstancesRepositoryProvider);
  return tasksRepository.watchTaskInstance(id);
});
