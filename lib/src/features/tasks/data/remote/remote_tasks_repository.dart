import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteTasksRepository {
  Future<Tasks> fetchTasks(String uid);

  Future<void> setTasks(String uid, Tasks tasks);

  Stream<Tasks> watchTasks(String uid);

  Stream<Task?> watchTask(String uid, String taskId);
}

final remoteTasksRepositoryProvider = Provider<RemoteTasksRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTasksListStreamProvider =
    StreamProvider.autoDispose.family<List<Task>, String>((ref, uid) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTasksListFutureProvider =
    FutureProvider.autoDispose.family<List<Task>, String>((ref, uid) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteTaskStreamProvider =
    StreamProvider.autoDispose.family<Task?, RemoteItem>((ref, remoteItem) {
  // * Override this in the main method
  throw UnimplementedError();
});
