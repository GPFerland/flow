import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_task_instances_repository.g.dart';

abstract class RemoteTaskInstancesRepository {
  // * create
  Future<void> createTaskInstance(
    String uid,
    TaskInstance taskInstance,
  );

  Future<void> createTaskInstances(
    String uid,
    List<TaskInstance> taskInstances,
  );

  // * read
  // fetch a task instance as a [Future] (one-time read)
  Future<TaskInstance?> fetchTaskInstance(
    String uid,
    String taskInstanceId,
  );

  // fetch all task instances as a [Future] (one-time read)
  Future<List<TaskInstance>> fetchTaskInstances(
    String uid,
  );

  // watch a task instance as a [Stream] (for realtime updates)
  Stream<TaskInstance?> watchTaskInstance(
    String uid,
    String taskInstanceId,
  );

  // watch all task instances as a [Stream] (for realtime updates)
  Stream<List<TaskInstance>> watchTaskInstances(
    String uid,
    DateTime? date,
  );

  // * update
  Future<void> updateTaskInstance(
    String uid,
    TaskInstance taskInstance,
  );

  Future<void> updateTaskInstances(
    String uid,
    List<TaskInstance> taskInstances,
  );

  // * delete
  Future<void> deleteTaskInstance(
    String uid,
    String taskInstanceId,
  );

  Future<void> deleteTaskInstances(
    String uid,
    List<String> taskInstanceIds,
  );

  // * query
  Query<TaskInstance> taskInstancesQuery(
    String uid,
  );
}

@Riverpod(keepAlive: true)
RemoteTaskInstancesRepository remoteTaskInstancesRepository(
    RemoteTaskInstancesRepositoryRef ref) {
  // * override in main()
  throw UnimplementedError();
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

@riverpod
Stream<List<TaskInstance>> remoteTaskInstancesStream(
  RemoteTaskInstancesStreamRef ref,
  String uid,
  DateTime? date,
) {
  final taskInstancesRepository = ref.watch(
    remoteTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.watchTaskInstances(uid, date);
}
