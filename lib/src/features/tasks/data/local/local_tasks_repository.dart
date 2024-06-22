import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local task data (guest user)
abstract class LocalTasksRepository {
  Future<Tasks> fetchTasks();

  Future<Task?> fetchTask(String id);

  Future<void> setTasks(Tasks tasks);

  Stream<Tasks> watchTasks();

  Stream<Task?> watchTask(String id);
}

final localTasksRepositoryProvider = Provider<LocalTasksRepository>((ref) {
  // * Override in main()
  throw UnimplementedError();
});

final localTasksStreamProvider = StreamProvider.autoDispose<Tasks>((ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTasks();
});

final localTasksFutureProvider = FutureProvider.autoDispose<Tasks>((ref) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTasks();
});

final localTaskStreamProvider =
    StreamProvider.autoDispose.family<Task?, String>((ref, id) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.watchTask(id);
});

final localTaskFutureProvider =
    FutureProvider.autoDispose.family<Task?, String>((ref, id) {
  final tasksRepository = ref.watch(localTasksRepositoryProvider);
  return tasksRepository.fetchTask(id);
});
