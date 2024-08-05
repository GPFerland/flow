import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_tasks_repository.g.dart';

abstract class RemoteTasksRepository {
  // * create
  Future<void> createTask(String uid, Task task);

  Future<void> createTasks(String uid, List<Task> task);

  // * read
  // fetch a task as a [Future] (one-time read)
  Future<Task?> fetchTask(String uid, String taskId);

  // fetch all tasks as a [Future] (one-time read)
  Future<List<Task>> fetchTasks(String uid);

  // watch a task as a [Stream] (for realtime updates)
  Stream<Task?> watchTask(String uid, String taskId);

  // watch all tasks as a [Stream] (for realtime updates)
  Stream<List<Task>> watchTasks(String uid);

  // * update
  Future<void> updateTask(String uid, Task task);

  Future<void> updateTasks(String uid, List<Task> tasks);

  // * delete
  Future<void> deleteTask(String uid, String taskId);

  Future<void> deleteTasks(String uid, List<String> taskIds);

  // * query
  Query<Task> tasksQuery(String uid);
}

@Riverpod(keepAlive: true)
RemoteTasksRepository remoteTasksRepository(RemoteTasksRepositoryRef ref) {
  // * Override in main()
  throw UnimplementedError();
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
Future<List<Task>> remoteTasksFuture(
  RemoteTasksFutureRef ref,
  String uid,
) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.fetchTasks(uid);
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

@riverpod
Stream<List<Task>> remoteTasksStream(
  RemoteTasksStreamRef ref,
  String uid,
) {
  final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
  return tasksRepository.watchTasks(uid);
}
