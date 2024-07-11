import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local taskInstance data (guest user)
abstract class LocalTaskInstancesRepository {
  Future<void> setTaskInstances(List<TaskInstance> taskInstances);

  Future<List<TaskInstance>> fetchTaskInstances();

  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId);

  Stream<List<TaskInstance>> watchTaskInstances({DateTime? date});

  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId);
}

final localTaskInstancesRepositoryProvider =
    Provider<LocalTaskInstancesRepository>(
  (ref) {
    // * Override in main()
    throw UnimplementedError();
  },
);

final localTaskInstancesFutureProvider =
    FutureProvider.autoDispose<List<TaskInstance>>(
  (ref) {
    final taskInstancesRepository =
        ref.watch(localTaskInstancesRepositoryProvider);
    return taskInstancesRepository.fetchTaskInstances();
  },
);

final localTaskInstanceFutureProvider =
    FutureProvider.autoDispose.family<TaskInstance?, String>(
  (ref, taskInstanceId) {
    final taskInstancesRepository =
        ref.watch(localTaskInstancesRepositoryProvider);
    return taskInstancesRepository.fetchTaskInstance(taskInstanceId);
  },
);

final localTaskInstancesStreamProvider =
    StreamProvider.autoDispose<List<TaskInstance>>(
  (ref) {
    final taskInstancesRepository =
        ref.watch(localTaskInstancesRepositoryProvider);
    return taskInstancesRepository.watchTaskInstances();
  },
);

final localTaskInstanceStreamProvider =
    StreamProvider.autoDispose.family<TaskInstance?, String>(
  (ref, taskInstanceId) {
    final taskInstancesRepository =
        ref.watch(localTaskInstancesRepositoryProvider);
    return taskInstancesRepository.watchTaskInstance(taskInstanceId);
  },
);
