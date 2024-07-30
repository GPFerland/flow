import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_task_instances_repository.g.dart';

abstract class LocalTaskInstancesRepository {
  Future<void> setTaskInstances(List<TaskInstance> taskInstances);

  Future<List<TaskInstance>> fetchTaskInstances();

  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId);

  Stream<List<TaskInstance>> watchTaskInstances({DateTime? date});

  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId);
}

@Riverpod(keepAlive: true)
LocalTaskInstancesRepository localTaskInstancesRepository(
  LocalTaskInstancesRepositoryRef ref,
) {
  // * Override in main()
  throw UnimplementedError();
}

@riverpod
Future<List<TaskInstance>> localTaskInstancesFuture(
  LocalTaskInstancesFutureRef ref,
) {
  final taskInstancesRepository = ref.watch(
    localTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.fetchTaskInstances();
}

@riverpod
Future<TaskInstance?> localTaskInstanceFuture(
  LocalTaskInstanceFutureRef ref,
  String taskInstanceId,
) {
  final taskInstancesRepository = ref.watch(
    localTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.fetchTaskInstance(taskInstanceId);
}

@riverpod
Stream<List<TaskInstance>> localTaskInstancesStream(
  LocalTaskInstancesStreamRef ref,
) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.watchTaskInstances();
}

@riverpod
Stream<TaskInstance?> localTaskInstanceStream(
  LocalTaskInstanceStreamRef ref,
  String taskInstanceId,
) {
  final taskInstancesRepository =
      ref.watch(localTaskInstancesRepositoryProvider);
  return taskInstancesRepository.watchTaskInstance(taskInstanceId);
}
