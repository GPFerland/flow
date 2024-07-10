import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local task data (guest user)
abstract class LocalTasksRepository {
  Future<void> setTasks(List<Task> tasks);

  Future<List<Task>> fetchTasks();

  Future<Task?> fetchTask(String taskId);

  Stream<List<Task>> watchTasks();

  Stream<Task?> watchTask(String taskId);
}

final localTasksRepositoryProvider = Provider<LocalTasksRepository>(
  (ref) {
    // * Override in main()
    throw UnimplementedError();
  },
);

final localTasksFutureProvider = FutureProvider.autoDispose<List<Task>>(
  (ref) {
    final tasksRepository = ref.watch(localTasksRepositoryProvider);
    return tasksRepository.fetchTasks();
  },
);

final localTaskFutureProvider =
    FutureProvider.autoDispose.family<Task?, String>(
  (ref, taskId) {
    final tasksRepository = ref.watch(localTasksRepositoryProvider);
    return tasksRepository.fetchTask(taskId);
  },
);

final localTasksStreamProvider = StreamProvider.autoDispose<List<Task>>(
  (ref) {
    final tasksRepository = ref.watch(localTasksRepositoryProvider);
    return tasksRepository.watchTasks();
  },
);

final localTaskStreamProvider =
    StreamProvider.autoDispose.family<Task?, String>(
  (ref, taskId) {
    final tasksRepository = ref.watch(localTasksRepositoryProvider);
    return tasksRepository.watchTask(taskId);
  },
);
