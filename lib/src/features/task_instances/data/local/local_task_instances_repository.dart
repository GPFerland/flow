import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_task_instances_repository.g.dart';

abstract class LocalTaskInstancesRepository {
  // * create
  Future<void> createTaskInstance(TaskInstance taskInstance);

  Future<void> createTaskInstances(List<TaskInstance> taskInstances);

  // * read
  // fetch a task instance as a [Future] (one-time read)
  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId);

  // fetch all task instances as a [Future] (one-time read)
  Future<List<TaskInstance>> fetchTaskInstances();

  // watch a task instance as a [Stream] (for realtime updates)
  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId);

  // watch all task instances as a [Stream] (for realtime updates)
  Stream<List<TaskInstance>> watchTaskInstances(DateTime? date);

  // * update
  Future<void> updateTaskInstance(TaskInstance taskInstance);

  Future<void> updateTaskInstances(List<TaskInstance> taskInstances);

  // * delete
  Future<void> deleteTaskInstance(String taskInstanceId);

  Future<void> deleteTaskInstances(List<String> taskInstanceIds);
}

@Riverpod(keepAlive: true)
LocalTaskInstancesRepository localTaskInstancesRepository(
  LocalTaskInstancesRepositoryRef ref,
) {
  // * override in main()
  throw UnimplementedError();
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
Future<List<TaskInstance>> localTaskInstancesFuture(
  LocalTaskInstancesFutureRef ref,
) {
  final taskInstancesRepository = ref.watch(
    localTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.fetchTaskInstances();
}

@riverpod
Stream<TaskInstance?> localTaskInstanceStream(
  LocalTaskInstanceStreamRef ref,
  String taskInstanceId,
) {
  final taskInstancesRepository = ref.watch(
    localTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.watchTaskInstance(taskInstanceId);
}

@riverpod
Stream<List<TaskInstance>> localTaskInstancesStream(
  LocalTaskInstancesStreamRef ref,
  DateTime? date,
) {
  final taskInstancesRepository = ref.watch(
    localTaskInstancesRepositoryProvider,
  );
  return taskInstancesRepository.watchTaskInstances(date);
}
