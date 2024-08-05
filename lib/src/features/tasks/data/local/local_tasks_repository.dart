import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_tasks_repository.g.dart';

abstract class LocalTasksRepository {
  // * create
  Future<void> createTask(Task task);

  Future<void> createTasks(List<Task> task);

  // * read
  // fetch a task as a [Future] (one-time read)
  Future<Task?> fetchTask(String taskId);

  // fetch all tasks as a [Future] (one-time read)
  Future<List<Task>> fetchTasks();

  // watch a task as a [Stream] (for realtime updates)
  Stream<Task?> watchTask(String taskId);

  // watch all tasks as a [Stream] (for realtime updates)
  Stream<List<Task>> watchTasks();

  // * update
  Future<void> updateTask(Task task);

  Future<void> updateTasks(List<Task> tasks);

  // * delete
  Future<void> deleteTask(String taskId);

  Future<void> deleteTasks(List<String> taskIds);
}

@Riverpod(keepAlive: true)
LocalTasksRepository localTasksRepository(LocalTasksRepositoryRef ref) {
  // * override in main()
  throw UnimplementedError();
}

@riverpod
Future<Task?> localTaskFuture(LocalTaskFutureRef ref, String taskId) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTask(taskId);
}

@riverpod
Future<List<Task>> localTasksFuture(LocalTasksFutureRef ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTasks();
}

@riverpod
Stream<Task?> localTaskStream(LocalTaskStreamRef ref, String taskId) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTask(taskId);
}

@riverpod
Stream<List<Task>> localTasksStream(LocalTasksStreamRef ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTasks();
}
