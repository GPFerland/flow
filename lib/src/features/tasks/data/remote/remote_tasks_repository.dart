import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_tasks_repository.g.dart';

abstract class RemoteTasksRepository {
  Future<void> setTasks(String uid, List<Task> tasks);

  Future<List<Task>> fetchTasks(String uid);

  Future<Task?> fetchTask(String uid, String taskId);

  Stream<List<Task>> watchTasks(String uid);

  Stream<Task?> watchTask(String uid, String taskId);
}

@Riverpod(keepAlive: true)
RemoteTasksRepository remoteTasksRepository(RemoteTasksRepositoryRef ref) {
  // * Override in main()
  throw UnimplementedError();
}

@riverpod
Future<List<Task>> remoteTasksFuture(RemoteTasksFutureRef ref, String uid) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.fetchTasks(uid);
}

@riverpod
Future<Task?> remoteTaskFuture(
  RemoteTaskFutureRef ref,
  String uid,
  String taskId,
) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.fetchTask(uid, taskId);
}

@riverpod
Stream<List<Task>> remoteTasksStream(RemoteTasksStreamRef ref, String uid) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.watchTasks(uid);
}

@riverpod
Stream<Task?> remoteTaskStream(
  RemoteTaskStreamRef ref,
  String uid,
  String taskId,
) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.watchTask(uid, taskId);
}
