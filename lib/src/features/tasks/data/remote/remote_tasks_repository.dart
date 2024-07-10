import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteTasksRepository {
  Future<void> setTasks(String uid, List<Task> tasks);

  Future<List<Task>> fetchTasks(String uid);

  Future<Task?> fetchTask(String uid, String taskId);

  Stream<List<Task>> watchTasks(String uid);

  Stream<Task?> watchTask(String uid, String taskId);
}

final remoteTasksRepositoryProvider = Provider<RemoteTasksRepository>(
  (ref) {
    // * Override in main()
    throw UnimplementedError();
  },
);

final remoteTasksFutureProvider =
    FutureProvider.autoDispose.family<List<Task>, String>(
  (ref, uid) {
    final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
    return tasksRepository.fetchTasks(uid);
  },
);

final remoteTaskFutureProvider =
    FutureProvider.autoDispose.family<Task?, RemoteItem>(
  (ref, remoteItem) {
    final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
    return tasksRepository.fetchTask(remoteItem.uid, remoteItem.itemId);
  },
);

final remoteTasksStreamProvider =
    StreamProvider.autoDispose.family<List<Task>, String>(
  (ref, uid) {
    final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
    return tasksRepository.watchTasks(uid);
  },
);

final remoteTaskStreamProvider =
    StreamProvider.autoDispose.family<Task?, RemoteItem>(
  (ref, remoteItem) {
    final tasksRepository = ref.watch(remoteTasksRepositoryProvider);
    return tasksRepository.watchTask(remoteItem.uid, remoteItem.itemId);
  },
);
