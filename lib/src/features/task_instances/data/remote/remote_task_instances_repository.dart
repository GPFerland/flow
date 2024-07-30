import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_task_instances_repository.g.dart';

abstract class RemoteTaskInstancesRepository {
  Future<void> setTaskInstances(String uid, List<TaskInstance> taskInstances);

  Future<List<TaskInstance>> fetchTaskInstances(String uid);

  Future<TaskInstance?> fetchTaskInstance(String uid, String taskInstanceId);

  Stream<List<TaskInstance>> watchTaskInstances(String uid, {DateTime? date});

  Stream<TaskInstance?> watchTaskInstance(String uid, String taskInstanceId);
}

@Riverpod(keepAlive: true)
RemoteTaskInstancesRepository remoteTaskInstancesRepository(
  RemoteTaskInstancesRepositoryRef ref,
) {
  // * Override in main()
  throw UnimplementedError();
}

@riverpod
Future<List<TaskInstance>> remoteTaskInstancesFuture(
  RemoteTaskInstancesFutureRef ref,
  String uid,
) {
  final taskInstancesRepository = ref.watch(
    remoteTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.fetchTaskInstances(uid);
}

@riverpod
Future<TaskInstance?> remoteTaskInstanceFuture(
  RemoteTaskInstanceFutureRef ref,
  String uid,
  String taskInstanceId,
) {
  final taskInstancesRepository = ref.watch(
    remoteTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.fetchTaskInstance(uid, taskInstanceId);
}

@riverpod
Stream<List<TaskInstance>> remoteTaskInstancesStream(
  RemoteTaskInstancesStreamRef ref,
  String uid,
) {
  final taskInstancesRepository = ref.watch(
    remoteTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.watchTaskInstances(uid);
}

@riverpod
Stream<TaskInstance?> remoteTaskInstanceStream(
  RemoteTaskInstanceStreamRef ref,
  String uid,
  String taskInstanceId,
) {
  final taskInstancesRepository = ref.watch(
    remoteTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.watchTaskInstance(uid, taskInstanceId);
}
