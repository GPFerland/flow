import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_tasks_repository.g.dart';

abstract class LocalTasksRepository {
  Future<void> setTasks(List<Task> tasks);

  Future<List<Task>> fetchTasks();

  Future<Task?> fetchTask(String taskId);

  Stream<List<Task>> watchTasks();

  Stream<Task?> watchTask(String taskId);
}

@Riverpod(keepAlive: true)
LocalTasksRepository localTasksRepository(LocalTasksRepositoryRef ref) {
  // * Override in main()
  throw UnimplementedError();
}

@riverpod
Future<List<Task>> localTasksFuture(LocalTasksFutureRef ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTasks();
}

@riverpod
Future<Task?> localTaskFuture(LocalTaskFutureRef ref, String taskId) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTask(taskId);
}

@riverpod
Stream<List<Task>> localTasksStream(LocalTasksStreamRef ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTasks();
}

@riverpod
Stream<Task?> localTaskStream(LocalTaskStreamRef ref, String taskId) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTask(taskId);
}
